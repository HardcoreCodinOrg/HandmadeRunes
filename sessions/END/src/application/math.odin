package application

import "core:math"
sqrt :: math.sqrt_f32;
sin  :: math.sin_f32;
cos  :: math.cos_f32;
pow  :: math.pow_f32;

Vector :: distinct [3]f32;
Matrix :: struct { X, Y, Z: Vector };


approach :: inline proc(current: ^Vector, target: ^Vector, delta: f32) {
    for target_value, i in target do switch {
        case current[i] + delta < target_value: current[i] += delta;
        case current[i] - delta > target_value: current[i] -= delta;
        case                                  : current[i]  = target_value;
    }
}

dot :: inline proc(lhs: ^Vector, rhs: ^Vector) -> f32 do return (
	lhs.x * rhs.x + 
	lhs.y * rhs.y + 
	lhs.z * rhs.z
);

dist :: inline proc(lhs: ^Vector, rhs: ^Vector) -> f32 {
    x := rhs.x - lhs.x;
    y := rhs.y - lhs.y;
    z := rhs.z - lhs.z;

    return sqrt(x*x + y*y + z*z);
}

setMatrixToIdentity :: inline proc(using matrix: ^Matrix) {
    X.x = 1; X.y = 0; X.z = 0;
    Y.x = 0; Y.y = 1; Y.z = 0;    
    Z.x = 0; Z.y = 0; Z.z = 1;
}

transposeMatrix :: inline proc(m: ^Matrix, using out: ^Matrix) {
    X.x = m.X.x;  X.y = m.Y.x;  Y.x = m.X.y;
    Y.y = m.Y.y;  X.z = m.Z.x;  Z.x = m.X.z; 
    Z.z = m.Z.z;  Y.z = m.Z.y;  Z.y = m.Y.z;
}

multiplyVectorByMatrixInPlace :: inline proc(lhs: ^Vector, using matrix: ^Matrix) {
    v := lhs^;
    m: Matrix;
    transposeMatrix(matrix, &m);

    lhs.x = dot(&v, &m.X);
    lhs.y = dot(&v, &m.Y);
    lhs.z = dot(&v, &m.Z);
}

multiplyMatrices :: inline proc(lhs: ^Matrix, rhs: ^Matrix, using out: ^Matrix) {
    rhsT: Matrix;
    transposeMatrix(rhs, &rhsT);

    LX := &lhs.X;  RX := &rhsT.X;
    LY := &lhs.Y;  RY := &rhsT.Y;
    LZ := &lhs.Z;  RZ := &rhsT.Z;

    X = {dot(LX, RX), dot(LX, RY), dot(LX, RZ)};
    Y = {dot(LY, RX), dot(LY, RY), dot(LY, RZ)};
    Z = {dot(LZ, RX), dot(LZ, RY), dot(LZ, RZ)};
}

yaw :: inline proc(angle: f32, using out: ^Matrix) {
    s := sin(angle);
    c := cos(angle);

    LX := X;
    LY := Y;
    LZ := Z;

    X.x = c*LX.x - s*LX.z;
    Y.x = c*LY.x - s*LY.z;
    Z.x = c*LZ.x - s*LZ.z;

    X.z = c*LX.z + s*LX.x;
    Y.z = c*LY.z + s*LY.x;
    Z.z = c*LZ.z + s*LZ.x;
};

pitch :: inline proc(angle: f32, using out: ^Matrix) {
    s := sin(angle);
    c := cos(angle);

    LX := X;
    LY := Y;
    LZ := Z;

    X.y = c*LX.y + s*LX.z;
    Y.y = c*LY.y + s*LY.z;
    Z.y = c*LZ.y + s*LZ.z;

    X.z = c*LX.z - s*LX.y;
    Y.z = c*LY.z - s*LY.y;
    Z.z = c*LZ.z - s*LZ.y;
};

rotate :: inline proc(using transform: ^Transform, yaw_angle, pitch_angle: f32) {
    if yaw_angle   != 0 do yaw(yaw_angle, &yaw_matrix);
    if pitch_angle != 0 do pitch(pitch_angle, &pitch_matrix);

    multiplyMatrices(&pitch_matrix, &yaw_matrix, &rotation_matrix);
}