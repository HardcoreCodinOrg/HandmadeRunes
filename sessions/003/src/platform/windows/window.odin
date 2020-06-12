package windows

import "../../application"

info: BITMAPINFO = {
	bmiHeader = {
    	biSize          = size_of(BITMAPINFOHEADER),
    	biPlanes        = 1,
    	biBitCount      = 32,
    	biCompression   = BI_RGB 
	}	
};

win_dc: HDC;
win_rect: RECT;
window: HWND;

import "core:runtime"

performance_counter: LARGE_INTEGER;

default_context: runtime.Context;
win32TicksPerSecond: u64;
win32GetTicks :: proc() -> u64 {
	QueryPerformanceCounter(&performance_counter);
	return u64(performance_counter.QuadPart);
}

WndProc:: proc "std" (hWnd: HWND, message: UINT, wParam: WPARAM, lParam: LPARAM) -> LRESULT {
	using application;
	using frame_buffer;
	using info.bmiHeader;
	using win_rect;

	context = default_context;

	switch message {
		case WM_SIZE:
			GetClientRect(window, &win_rect);
			biWidth  = right - left; 
		    biHeight = top - bottom;
		    resize(u32(biWidth), u32(-biHeight));

		case WM_PAINT:
			update();
		    SetDIBitsToDevice(win_dc, 0, 0, width, height,
		                              0, 0, 0,     height,
		                      bits, &info, DIB_RGB_COLORS);
		    ValidateRgn(window, nil);

        case WM_DESTROY:
        	is_running = false;
        	PostQuitMessage(0);

		case:
			return DefWindowProcA(hWnd, message, wParam, lParam);
	}

	return 0;
}

run_application :: proc() {
	using application;
	default_context = context;

	performance_frequency: LARGE_INTEGER;
	QueryPerformanceFrequency(&performance_frequency);
	win32TicksPerSecond = u64(performance_frequency.QuadPart);

	target_ticks_per_frame := win32TicksPerSecond / 60;

	initApplication(win32GetTicks, win32TicksPerSecond);

	HInstance: HINSTANCE = transmute(HINSTANCE)GetModuleHandleA(nil);
	window_class: WNDCLASSA = {
	    lpszClassName  = class_name,
	    hInstance      = HInstance,
	    lpfnWndProc    = WndProc,
	    style          = CS_OWNDC|CS_HREDRAW|CS_VREDRAW|CS_DBLCLKS,
	    hCursor        = LoadCursorA(nil, IDC_ARROW)
	};
	result := RegisterClassA(&window_class);
	when ODIN_DEBUG do asset(result != 0, "Failed to register class!");

    window = CreateWindowExA(0, class_name, "Application", WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        INITIAL_WIDTH, 
        INITIAL_HEIGHT, 
        nil, nil, HInstance, nil);
    when ODIN_DEBUG do assert(window != nil, "Failed to create window!");

    win_dc = GetDC(window);
    ShowWindow(window, SW_SHOWDEFAULT);
    message: MSG;

    prior_frame_ticks: u64;
    current_frame_ticks := win32GetTicks();

    for is_running {
    	// [###][###][###][###]
    	// [###................|##..................|####..............]
    	// 60Hz -> TPS / 60

    	prior_frame_ticks, current_frame_ticks = current_frame_ticks, win32GetTicks();
    	for (current_frame_ticks - prior_frame_ticks < target_ticks_per_frame) do 
    		current_frame_ticks = win32GetTicks();

		for PeekMessageA(&message, nil, 0, 0, PM_REMOVE) {
			TranslateMessage(&message);
            DispatchMessageA(&message);	
		}
		InvalidateRgn(window, nil, false);
    }
}