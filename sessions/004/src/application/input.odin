package application

move_right,
move_left,
move_up,
move_down: bool;

keyChanged :: proc(key: u8, pressed: bool) {
	switch key {
		case 'W': move_up    = pressed;
		case 'S': move_down  = pressed;
		case 'A': move_left  = pressed;
		case 'D': move_right = pressed;	
	}
}

MouseButton :: struct { is_pressed: bool }
Mouse :: struct {
	buttons: struct { middle, right, left: MouseButton },
	wheel: struct { scrolled: bool, scroll_amount: i16 },
	position, delta: [2]i32,
	is_captured: bool
}
mouse: Mouse;

setMouseButtonState :: proc(button: ^MouseButton, state: bool) {
	button.is_pressed = state;
}

setMouseWheel :: proc(amount: f32) {
	mouse.wheel.scroll_amount += i16(amount * 100);
	mouse.wheel.scrolled = true;
}

mouseMoved :: proc(x, y: i32) {
	print("X:", x, "Y:", y);
	mouse.delta.x = x;
	mouse.delta.y = y;
}