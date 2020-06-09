package application

import "core:mem"

MAX_WIDTH  :: 3840;
MAX_HEIGHT :: 2160;
MAX_SIZE   :: MAX_WIDTH * MAX_HEIGHT;
PIXEL_SIZE :: 4;

Color :: struct #packed {
	B, G, R, A: u8
}
Pixel :: struct #raw_union {
	value: u32,
	color: Color
}

FrameBuffer :: struct {
	pixels: ^[MAX_SIZE]Pixel,
	width, height: u16
};
frame_buffer: FrameBuffer = {
	pixels = cast(^[MAX_SIZE]Pixel)(mem.alloc(MAX_SIZE * PIXEL_SIZE))
};

resize :: proc(new_width, new_height: u16) {
	using frame_buffer;
	width = new_width;
	height = new_height;
}

update :: proc() {
	using frame_buffer;
	
	index: u32;
	pixel: ^Pixel;

	// u32:
	// 00000000_00000000_00000000_00000000
	// AAAAAAAA_RRRRRRRR_GGGGGGGG_BBBBBBBB
	// AAAAAAAA_BBBBBBBB_GGGGGGGG_RRRRRRRR

	for h in 0..<height {
		for w in 0..<width {
			pixel = &pixels[index];
			pixel.color.G = u8(w);
			pixel.color.B = u8(h);

			index += 1;
		}		
	}
}

is_running: bool = true;
class_name :: "Application";