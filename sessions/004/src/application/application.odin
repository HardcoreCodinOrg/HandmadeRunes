package application

import "core:fmt"
print :: fmt.println;

SPEED :: 240;
PAN_SPEED :: 3;
TARGET_FPS :: 60;
UPDATE_INTERVAL: u64;

is_running: bool = true;
class_name :: "Application";

offset: [2]f64;

resize :: proc(new_width, new_height: u32) {
	resizeFrameBuffer(new_width, new_height);
	update();	
}

update :: proc() {
	using update_timer;

	after = getTicks();
	delta = after - before;

	amount := SPEED * (f64(delta) * seconds_per_tick);
	if move_right do offset.x += amount;
	if move_left  do offset.x -= amount;
	if move_up    do offset.y -= amount;
	if move_down  do offset.y += amount;

	if mouse.is_captured || mouse.buttons.middle.is_pressed {	
		if mouse.delta.x != 0 do offset.x -= amount * f64(mouse.delta.x) * PAN_SPEED;
		if mouse.delta.y != 0 do offset.y -= amount * f64(mouse.delta.y) * PAN_SPEED;
		mouse.delta.x = 0;
		mouse.delta.y = 0;
	}

	if mouse.wheel.scrolled {
		print(mouse.wheel.scroll_amount);
		mouse.wheel.scrolled = false;
	}

	before = getTicks();

	render();
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