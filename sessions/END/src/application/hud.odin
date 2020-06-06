package application

HUD_WIDTH :: 12;
HUD_RIGHT :: 100;
HUD_TOP :: 10;
String :: struct {data: ^byte, len:  int};

template :: `
Width  : 1___
Height : 2___
FPS    : 3___
Ms/F   : 4___
Mode   : 5___`;

	
HUD ::struct {
	_buf: [len(template)]byte
    text: []byte,
    str: string,
    color: Color,
    labels: struct { width, height, fps, msf, mode, zoom: []byte},
    is_visible: bool
};
hud: HUD;

initHUD :: proc() {
    using hud;

    is_visible = true;
    text = _buf[:];
    str = transmute(string)String{&_buf[0], len(text)};
	color.G = 0xFF;

    using labels;
    for character, i in template {
        switch character {
            case '1':  width  = _buf[i:i+4];
            case '2':  height = _buf[i:i+4];
            case '3':  fps    = _buf[i:i+4];
            case '4':  msf    = _buf[i:i+4];
            case '5':  mode   = _buf[i:i+4];
        }
        _buf[i] = byte(character);
    }

    updateCountersInHUD();
    updateControllerModeInHUD();
}

updateControllerModeInHUD :: proc() {
    using hud.labels;
    mode[0] = ' ';
    mode[1] = in_fps_mode ? 'F' : 'O';
    mode[2] = in_fps_mode ? 'p' : 'r';
    mode[3] = in_fps_mode ? 's' : 'b'; 
}

updateCountersInHUD :: proc() {
    using hud.labels;
    using perf.avg;
    printNumberIntoString(u16(frames_per_second), fps);
    printNumberIntoString(u16(milliseconds_per_frame), msf);
}

updateDimensionsInHUD :: proc(new_width, new_height: u16) {
    using hud.labels;
    printNumberIntoString(new_width, width);
    printNumberIntoString(new_height, height);
}