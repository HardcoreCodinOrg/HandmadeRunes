package application

INITIAL_WIDTH  :: 640;
INITIAL_HEIGHT :: 480;

MAX_WIDTH  :: 3840;
MAX_HEIGHT :: 2160;
MAX_SIZE   :: MAX_WIDTH * MAX_HEIGHT;

FrameBuffer :: struct {
	using bitmap: Bitmap,
	bits: ^[MAX_SIZE]u32
};
frame_buffer, canvas: FrameBuffer;

initFrameBuffer :: proc(using fb: ^FrameBuffer) {
	bits = new([MAX_SIZE]u32);
	resizeFrameBuffer(fb, MAX_WIDTH, MAX_HEIGHT);	
}

resizeFrameBuffer :: proc(using fb: ^FrameBuffer, new_width, new_height: i32) {
	initBitmap(&bitmap, new_width, new_height, bits^[:]);
}

drawHLine :: inline proc(using bitmap: ^Bitmap, start, end, y: i32, color: ^Color) do
	for x in start..end do 
		if x < width do pixels[y][x].color = color^;

drawVLine :: inline proc(using bitmap: ^Bitmap, start, end, x: i32, color: ^Color) do
	for y in start..end do 
		if y < height do pixels[y][x].color = color^;

drawBitmap :: proc(from, to: ^Bitmap, pos: Coords2D) {
	if pos.x > to.width ||
	    pos.y > to.height ||
	    pos.x + from.width < 0 ||
	    pos.y + from.height < 0 do
	    return;

	to_start: Coords2D = {
		max(pos.x, 0),
		max(pos.y, 0)
	}; 
	to_end: Coords2D = {
		min(pos.x+from.width, to.width),
		min(pos.y+from.height, to.height)
	};

	pixel: ^Pixel;
	for y in to_start.y..<to_end.y {
		for x in to_start.x..<to_end.x {
			pixel = &from.pixels[y - pos.y][x - pos.x];
			if pixel.A != 0 do to.pixels[y][x] = pixel^;
		} 
	}
}

drawBounds :: proc(using bitmap: ^Bitmap, using b: ^Bounds2D, color: ^Color) {
	if min.y < height do drawHLine(bitmap, min.x, max.x, min.y, color);
	if max.y < height do drawHLine(bitmap, min.x, max.x, max.y, color);

	if min.x < width do drawVLine(bitmap, min.y, max.y, min.x, color);
	if max.x < width do drawVLine(bitmap, min.y, max.y, max.x, color);
}

drawWeirdColors :: proc() {
	using frame_buffer;

	for line, y in &pixels {
		for pixel, x in &line {
			using pixel.color;
			B = u8(f64(y) * zoom + pan.y);
			G = u8(f64(x) * zoom + pan.x);
			R = 0;
		}
	}

}