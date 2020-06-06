package application

SPHERE_RADIUS :: 1;
SPHERE_HCOUNT :: 3;
SPHERE_VCOUNT :: 3;
SPHERE_COUNT :: SPHERE_HCOUNT * SPHERE_VCOUNT;

Sphere :: struct { 
    radius: f32,
    world_position, view_position: Vector
};

RayHit :: struct { 
    distance: f32,
    position, normal: Vector
};
RayTracer :: struct { 
    closest_hit: RayHit, 
    ray_directions: [MAX_SIZE]Vector,
    spheres: [SPHERE_COUNT]Sphere
};
ray_tracer: RayTracer;

initRayTracer :: proc() {
    using ray_tracer;

    gap: u8 = SPHERE_RADIUS * 3;
    sphere_x: u8 = 0;
    sphere_z: u8 = 0;
    sphere_index: u8 = 0;

    sphere: ^Sphere;
    using sphere;

    for z: u8 = 0; z < SPHERE_VCOUNT; z += 1 {
        sphere_x = 0;

        for x: u8 = 0; x < SPHERE_HCOUNT; x += 1 {
            sphere = &spheres[sphere_index];
            radius = 1;

            world_position.x = f32(sphere_x);
            world_position.y = 0.0;
            world_position.z = f32(sphere_z);

            sphere_x += gap;
            sphere_index += 1;
        }

        sphere_z += gap;
    }
}

traceRays :: proc() {
	using ray_tracer;
	using frame_buffer;

    for i in 0..<size do
        if rayIntersectsWithSpheres(&ray_directions[i]) do
            shadePixelByNormalAndDistance(&pixels[i]);
        else do
            pixels[i].value = 0;
}

generateRays :: proc() {
	using ray_tracer;

	height := i32(frame_buffer.height);
	width  := i32(frame_buffer.width);

    z := f32(width) * camera.focal_length;
    z2 := z * z;
    factor, y2_plus_z2: f32;
    
    ray_index: u32 = 0;
    for y: i32 = height - 1; y > -height; y -= 2 {
        y2_plus_z2 = f32(y*y) + z2;
        for x: i32 = 1 - width; x < width; x += 2 {
            factor = 1.0 / sqrt(f32(x*x) + y2_plus_z2);
            ray_tracer.ray_directions[ray_index] = {
                f32(x) * factor,
                f32(y) * factor,
                f32(z) * factor
            };                       
            ray_index += 1;
        }
    }
}

MAX_COLOR :: 0xFF;

shadePixelByNormalAndDistance :: inline proc(using pixel: ^Pixel) {
    using ray_tracer.closest_hit;

    factor: f32 = 4.0 * MAX_COLOR / distance;
    color.R = u8(clamp(factor * (normal.x + 1.0), 0, MAX_COLOR));
    color.G = u8(clamp(factor * (normal.y + 1.0), 0, MAX_COLOR));
    color.B = u8(clamp(factor * (normal.z + 1.0), 0, MAX_COLOR));
}

rayIntersectsWithSpheres :: proc(ray_direction: ^Vector) -> bool {
    using ray_tracer.closest_hit; // The hit structure of the closest intersection of the ray with the spheres
    r, r2, // The radius of the current sphere (and it's square)
    d, d2, // The distance from the origin to the position of the current intersection (and it's square)
    o2c, // The distance from the ray's origin to a position along the ray closest to the current sphere's center
    O2C, // The distance from the ray's origin to that position along the ray for the closest intersection
    r2_minus_d2, // The square of the distance from that position to the current intersection position
    R2_minus_D2: f32; // The square of the distance from that position to the closest intersection position
    R: f32 = 0; // The radius of the closest intersecting sphere
    D: f32 = 100000; // The distance from the origin to the position of the closest intersection yet - squared

    _t, _p: Vector;
    s: ^Vector; // The center position of the sphere of the current intersection
    S: ^Vector; // The center position of the sphere of the closest intersection yet
    p := &_p; // The position of the current intersection of the ray with the spheres
    t := &_t;

    // Loop over all the spheres and intersect the ray against them:
    sphere: ^Sphere;        
    for i in 0..<SPHERE_COUNT {
        sphere = &ray_tracer.spheres[i];
        using sphere;
        s = &view_position;
        r = radius;
        r2 = r*r;

        o2c = dot(ray_direction, s);
        if o2c > 0 {
            p^ = ray_direction^ * o2c;
            t^ = s^ - p^;
            d2 = dot(t, t);
            if d2 <= r2 {
                r2_minus_d2 = r2 - d2;
                d = o2c - r2_minus_d2;
                if ((d > 0) && (d <= D)) {
                    S = s; D = d; R = r; O2C = o2c; R2_minus_D2 = r2_minus_d2;
                    position.x = p.x;
                    position.y = p.y;
                    position.z = p.z;
                }
            }
        }
    }

    if R != 0 {
        if R2_minus_D2 > 0.001 {
            distance = O2C - sqrt(R2_minus_D2);
            position = ray_direction^;
            position *= distance;
        }

        normal = position - S^;
        if R != 1 do normal /= R;

        return true;
    } else do
        return false;
}