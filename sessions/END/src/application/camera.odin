package application

Transform :: struct {
    yaw_matrix, 
    pitch_matrix, 
    roll_matrix,
    rotation_matrix,
    rotation_matrix_inverted: Matrix,

    position: Vector,
    
    up_direction, 
    right_direction, 
    forward_direction: ^Vector
};

initTransform :: proc(using transform: ^Transform) {
    setMatrixToIdentity(&rotation_matrix);
    setMatrixToIdentity(&rotation_matrix_inverted);
    setMatrixToIdentity(&yaw_matrix);
    setMatrixToIdentity(&pitch_matrix);
    setMatrixToIdentity(&roll_matrix);

    using rotation_matrix;
    right_direction   = &X;
    up_direction      = &Y;
    forward_direction = &Z;
}
camera: Camera;

initCamera :: proc() {
    camera.focal_length = 2;
    initTransform(&camera.transform);
}

Camera :: struct {
    focal_length: f32,
    transform: Transform
};

Controller :: struct {
    moved, 
    rotated, 
    zoomed: bool
};
FpsController :: struct { using controller: Controller,
    max_velocity, 
    max_acceleration, 
    orientation_speed,
    zoom_speed,
    zoom_amount: f32,

    target_velocity, 
    current_velocity: Vector
};
OrbController :: struct { using controller: Controller,
    dolly_amount,
    dolly_speed: i16,

    pan_speed, 
    orbit_speed,
    target_distance: f32,
    target: Vector
};

ORB_TARGET_DISTANCE :: 10;

orb_controller: OrbController = {
    pan_speed = 1.0 / 100,
    dolly_speed = 1,
    orbit_speed = 2.0 / 1000,
    target_distance = ORB_TARGET_DISTANCE
};


onMouseScrolledOrb :: proc() { // Dolly
    using orb_controller;
    using camera.transform;

    dolly_amount += mouse.wheel.scroll_amount * dolly_speed;
    target_distance = ORB_TARGET_DISTANCE * pow(2, f32(dolly_amount) / -200);
    position = target - target_distance*forward_direction^;
    
    moved = true;
}

onMouseMovedOrb ::proc() {
    using orb_controller;
    using camera.transform;

    x := f32(mouse.relative.x);
    y := f32(mouse.relative.y);

    if mouse.right_button.is_down { // Orbit
        rotate( 
            transform   = &camera.transform,
            yaw_angle   = orbit_speed * -x, 
            pitch_angle = orbit_speed * -y
        );
        position = target - target_distance*forward_direction^;

        rotated = true;
        moved = true;
    } else if mouse.middle_button.is_down { // Pan
        movement := right_direction^ * (pan_speed * -x);
        movement +=    up_direction^ * (pan_speed * +y);

        position += movement;
        target   += movement;

        moved = true;
    }
}

// First Person Shooter controller:
// ================================


fps_controller: FpsController = {
    max_velocity = 8,
    max_acceleration = 20,
    orientation_speed = 2.0 / 1000,
    zoom_speed = 0.005,
    zoom_amount = camera.focal_length
};

onMouseScrolledFps :: proc() {
    camera.focal_length += fps_controller.zoom_speed * f32(mouse.wheel.scroll_amount);
    fps_controller.zoom_amount = camera.focal_length;
    fps_controller.zoomed = true;
}

onMouseMovedFps :: proc() {
    rotate(
        transform   = &camera.transform,
        yaw_angle   = -f32(mouse.relative.x) * fps_controller.orientation_speed,
        pitch_angle = -f32(mouse.relative.y) * fps_controller.orientation_speed
    );
    fps_controller.rotated = true;
}

onUpdateFps :: proc() {
    using fps_controller;
    
    // Compute the target velocity:
    target_velocity.x = 0;
    target_velocity.y = 0;
    target_velocity.z = 0;

    using keyboard;
    if move_right.is_pressed     do target_velocity.x += max_velocity;
    if move_left.is_pressed      do target_velocity.x -= max_velocity;
    if move_up.is_pressed        do target_velocity.y += max_velocity;
    if move_down.is_pressed      do target_velocity.y -= max_velocity;
    if move_forward.is_pressed   do target_velocity.z += max_velocity;
    if move_backward.is_pressed  do target_velocity.z -= max_velocity;

    // Update the current velocity:
    delta_time := clamp(perf.delta.seconds, 0, 1);
    approach(
        &current_velocity, 
        &target_velocity, 
        max_acceleration * delta_time
    );

    moved = current_velocity.x != 0 || 
            current_velocity.y != 0 || 
            current_velocity.z != 0;
    if moved { // Update the current position:
        movement := current_velocity * delta_time;

        using camera.transform;
        position.y += movement.y;
        position.z += movement.x * yaw_matrix.X.z + movement.z * yaw_matrix.Z.z;
        position.x += movement.x * yaw_matrix.X.x + movement.z * yaw_matrix.Z.x;
    }
}
