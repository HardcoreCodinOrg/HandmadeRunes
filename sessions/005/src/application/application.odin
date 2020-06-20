package application

import "core:fmt"
print :: fmt.println;

SPEED :: 240;
PAN_SPEED :: 3;
TARGET_FPS :: 60;
UPDATE_INTERVAL: u64;

is_running: bool = true;
class_name :: "Application";

pan: [2]f64;
zoom: f64 = 1;

Bounds2D :: struct { min, max: Coords2D }
bounds: Bounds2D;
stored_bounds: [dynamic]Bounds2D;

resize :: proc(new_width, new_height: u32) {
	resizeFrameBuffer(new_width, new_height);
	update();	
}

update :: proc() {
	using mouse;
	using frame_buffer;
	using update_timer;

	after = getTicks();
	delta = after - before;

	amount := SPEED * (f64(delta) * seconds_per_tick);
	if move_right do pan.x += amount;
	if move_left  do pan.x -= amount;
	if move_up    do pan.y -= amount;
	if move_down  do pan.y += amount;

	if is_captured || buttons.middle.is_pressed {	
		if delta_pos.x != 0 do pan.x -= amount * f64(delta_pos.x) * PAN_SPEED;
		if delta_pos.y != 0 do pan.y -= amount * f64(delta_pos.y) * PAN_SPEED;
		delta_pos.x = 0;
		delta_pos.y = 0;
	}

	if wheel.scrolled {
		// -200  -150  -100  -50  0   50  100  150  200
		//   8     6     4    2   1  1/2  1/4  1/6  1/8                 
		if wheel.scroll_amount == 0     do zoom = 1;
		else if wheel.scroll_amount > 0 do zoom = 50 / (2 * f64(wheel.scroll_amount));
		else                            do zoom = (-2 * f64(wheel.scroll_amount)) / 50;
		wheel.scrolled = false;
	}

	before = getTicks();

	render();

	if len(stored_bounds) > 0 do
		for current_stored_bounds in &stored_bounds do
			drawBounds(&current_stored_bounds, &RED);

	if buttons.left.is_pressed {
		using bounds;
		// for y in pos.y..(pos.y+5) do
		// 	for x in pos.x..(pos.x+5) do
		// 		lines[y][x].color.R = 0xFF;

		min = buttons.left.down_pos;
		max = pos;

		if min.x > max.x do min.x, max.x = max.x, min.x;
		if min.y > max.y do min.y, max.y = max.y, min.y;

		drawBounds(&bounds, &WHITE);
	}

	if buttons.right.is_pressed {
		using bounds;
		min = buttons.right.down_pos;
		max = pos;

		if min.x > max.x do min.x, max.x = max.x, min.x;
		if min.y > max.y do min.y, max.y = max.y, min.y;

		drawBounds(&bounds, &RED);
	} else if buttons.right.is_released {
		buttons.right.is_released = false;

		using bounds;
		min = buttons.right.down_pos;
		max = buttons.right.up_pos;

		if min.x > max.x do min.x, max.x = max.x, min.x;
		if min.y > max.y do min.y, max.y = max.y, min.y;

		append(&stored_bounds, bounds);
	}
}

render :: proc() {
	using render_timer;

	before = getTicks();
	drawWeirdColors();
	after = getTicks();	

	accumulateTimer(&render_timer);

	if (after - ticks_of_last_report) >= ticks_per_second {
		// print(
		// 	"Frame count:", accumulated_frame_count,
		// 	"Average microseconds per frame:", 
		// 	u64(
		// 		microseconds_per_tick * (
		// 			f64(accumulated_ticks) / 
		// 			f64(accumulated_frame_count)
		// 		)
		// 	)
		// );

		accumulated_ticks = 0;
		accumulated_frame_count = 0;
		ticks_of_last_report = after;
	}
}


initApplication :: proc(platformGetTicks: GetTicks, platformTicksPerSecond: u64) {
	initTimers(platformGetTicks, platformTicksPerSecond);
	initFrameBuffer();

	UPDATE_INTERVAL = ticks_per_second / TARGET_FPS;
}