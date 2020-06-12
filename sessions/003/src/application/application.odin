package application

import "core:mem"

is_running: bool = true;
class_name :: "Application";

INITIAL_WIDTH  :: 800;
INITIAL_HEIGHT :: 640;

MAX_WIDTH  :: 3840;
MAX_HEIGHT :: 2160;
MAX_SIZE   :: MAX_WIDTH * MAX_HEIGHT;

Color :: struct #packed {
	B, G, R, A: u8
}
Pixel :: struct #raw_union {
	value: u32,
	color: Color
}
HorizontalPixelLine :: []Pixel;

FrameBuffer :: struct {
	bits: ^[MAX_SIZE]u32,
	all_pixels: HorizontalPixelLine,
	all_lines: [MAX_HEIGHT]HorizontalPixelLine,
	lines: []HorizontalPixelLine,

	width, height: u32
};
frame_buffer: FrameBuffer = { bits = new([MAX_SIZE]u32) };

resize :: proc(new_width, new_height: u32) {
	using frame_buffer;
	width = new_width;
	height = new_height;

	start: u32;
	end := width;

	for y in 0..<height {
		all_lines[y] = all_pixels[start:end];
		start += width;
		end   += width;
	}

	lines = all_lines[:height];
}

old_render :: proc() {
	using frame_buffer;
	
	index: u32;
	pixel: ^Pixel;

	for h in 0..<height {
		for w in 0..<width {
			pixel = cast(^Pixel)(&bits[index]);
			pixel.color.G = u8(w);
			pixel.color.B = u8(h);

			index += 1;
		}		
	}
}

render :: proc() {
	using frame_buffer;

	for line, y in &lines {
		for pixel, x in &line {
			using pixel.color;
			B = u8(y);
			G = u8(x);
		}
	}
}

before, 
after, 
delta,
accumulated_ticks,
accumulated_frame_count,
ticks_of_last_report,
milliseconds,
microseconds: u64;

milliseconds_per_tick,
microseconds_per_tick: f64;


pre_render :: proc() {
	before = getTicks();
}

import "core:fmt"

post_render :: proc() {
	after = getTicks();	
	delta = after - before;
	accumulated_ticks += delta;

	milliseconds = u64(milliseconds_per_tick * f64(delta));
	microseconds = u64(microseconds_per_tick * f64(delta));

	accumulated_frame_count += 1;

	if (after - ticks_of_last_report) >= ticks_per_second {
		fmt.println(
			"Framc count:", accumulated_frame_count,
			"Average FPS:", 
			1_000_000 / u64(
				microseconds_per_tick * (
					f64(accumulated_ticks) / 
					f64(accumulated_frame_count)
				)
			)
		);

		accumulated_ticks = 0;
		accumulated_frame_count = 0;
		ticks_of_last_report = after;
	}
}

update :: proc() {
	pre_render();
	render();
	post_render();
}

GetTicks :: proc() -> u64;
getTicks: GetTicks;
ticks_per_second: u64; 

initApplication :: proc(platformGetTicks: GetTicks, platformTicksPerSecond: u64) {
	getTicks = platformGetTicks;
	ticks_per_second = platformTicksPerSecond;

	milliseconds_per_tick = 1_000     / f64(ticks_per_second);
	microseconds_per_tick = 1_000_000 / f64(ticks_per_second);

	ticks_of_last_report = getTicks();

	using frame_buffer;
	all_pixels = transmute(HorizontalPixelLine)(bits^[:]);
}