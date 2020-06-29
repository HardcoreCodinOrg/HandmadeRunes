package application

move_right,
move_left,
move_up,
move_down: bool;

Keyboard :: struct { up, down, left, right, exit: u8 }
keyboard: Keyboard;

keyChanged :: proc(key: u8, pressed: bool) {
	switch key {
		case keyboard.up   : move_up    = pressed;
		case keyboard.down : move_down  = pressed;
		case keyboard.left : move_left  = pressed;
		case keyboard.right: move_right = pressed;	
		case keyboard.exit : is_running = false;
	}
}

Coords2D :: [2]i32;
MouseButton :: struct { 
	is_pressed,
	is_released: bool, 

	down_pos, 
	up_pos: Coords2D 
}
Mouse :: struct {
	buttons: struct { middle, right, left: MouseButton },
	wheel: struct { scrolled: bool, scroll_amount: i16 },
	pos, delta_pos: Coords2D,
	is_captured: bool
}
mouse: Mouse;

setMouseButtonDown :: proc(button: ^MouseButton, x, y: i32) {
	button.is_pressed = true;
	button.is_released = false;
	
	button.down_pos.x = x;
	button.down_pos.y = y;
}

setMouseButtonUp :: proc(button: ^MouseButton, x, y: i32) {
	button.is_released = true;
	button.is_pressed = false;
	
	button.up_pos.x = x;
	button.up_pos.y = y;
}

setMouseWheel :: proc(amount: f32) {
	mouse.wheel.scroll_amount += i16(amount * 100);
	mouse.wheel.scrolled = true;
}

setMousePosition :: proc(x, y: i32) {
	mouse.pos.x = x;
	mouse.pos.y = y;
}

setMouseMovement :: proc(x, y: i32) {
	mouse.delta_pos.x = x;
	mouse.delta_pos.y = y;
}