package application

Key :: struct { key_code: u32,  is_pressed: bool};
Keyboard :: struct {
    move_forward,   
    move_backward,    
    move_left,
    move_right,
    move_up,
    move_down, 
    toggle_hud: Key 
};

keyboard: Keyboard = {
    move_forward  = { key_code = 'W'},
    move_backward = { key_code = 'S'},
    move_left     = { key_code = 'A'},
    move_right    = { key_code = 'D'},
    move_up       = { key_code = 'R'},
    move_down     = { key_code = 'F'},
    toggle_hud    = { key_code = 'H'}
};

onKeyChanged :: inline proc(key_code: u32, is_pressed: bool) {
    using keyboard;
    switch key_code {
        case toggle_hud.key_code:       toggle_hud.is_pressed = is_pressed;
        case move_up.key_code:             move_up.is_pressed = is_pressed;
        case move_down.key_code:         move_down.is_pressed = is_pressed;
        case move_left.key_code:         move_left.is_pressed = is_pressed;
        case move_right.key_code:       move_right.is_pressed = is_pressed;
        case move_forward.key_code:   move_forward.is_pressed = is_pressed;
        case move_backward.key_code: move_backward.is_pressed = is_pressed;
    }
}

MouseCoords :: struct { changed: bool, x, y: i32 };
MouseButton :: struct { is_down: bool, up, down: MouseCoords };
Mouse :: struct {
    is_captured, double_clicked: bool,
    
    absolute, 
    relative: MouseCoords,

    left_button, 
    right_button, 
    middle_button: MouseButton,

    wheel: struct {
        scrolled: bool, 
        scroll_amount: i16
    }
};
mouse: Mouse;

onMouseMovedAbsolute :: inline proc(x, y: i32) {
    using mouse;
	absolute.changed = true;
    absolute.x = x;
    absolute.y = y;
}

onMouseMovedRelative :: inline proc(x, y: i32) {
    using mouse;
    relative.changed = true;
    relative.x += x;
    relative.y += y;
}

onMouseButtonDown :: inline proc(using button: ^MouseButton, x, y: i32) {
    is_down = true;
    down.x = x;
    down.y = y;
}

onMouseButtonUp :: inline proc(using button: ^MouseButton, x, y: i32) {
    is_down = false;
    up.x = x;
    up.y = y;
}

onMouseWheelScrolled :: inline proc(amount: f32) {
    mouse.wheel.scroll_amount += i16(amount * 100);
    mouse.wheel.scrolled = true;
}