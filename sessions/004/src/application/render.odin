package application

INITIAL_WIDTH  :: 640;
INITIAL_HEIGHT :: 480;

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
frame_buffer: FrameBuffer;

initFrameBuffer :: proc() {
	using frame_buffer;

	bits = new([MAX_SIZE]u32);
	all_pixels = transmute(HorizontalPixelLine)(bits^[:]);
}

resizeFrameBuffer :: proc(new_width, new_height: u32) {
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


drawWeirdColors :: proc() {
	using frame_buffer;

	for line, y in &lines {
		for pixel, x in &line {
			using pixel.color;
			B = u8(f64(y) + offset.y);
			G = u8(f64(x) + offset.x);
		}
	}

}