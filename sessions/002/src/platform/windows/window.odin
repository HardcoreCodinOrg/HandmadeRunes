package windows

import "../../application"


INITIAL_WIDTH  :: 800;
INITIAL_HEIGHT :: 600;

info: BITMAPINFO = {
	bmiHeader = {
    	biSize          = size_of(BITMAPINFOHEADER),
    	biWidth         = INITIAL_WIDTH, 
    	biHeight        = INITIAL_HEIGHT,
    	biPlanes        = 1,
    	biBitCount      = 32,
    	biCompression   = BI_RGB 
	}	
};

win_dc: HDC;
win_rect: RECT;
window: HWND;

import "core:runtime"

default_context: runtime.Context;

WndProc:: proc "std" (
	hWnd: HWND, 
	message: UINT, 
	wParam: WPARAM, 
	lParam: LPARAM
) -> LRESULT {
	context = default_context;

	switch message {

		case WM_SIZE:
			GetClientRect(window, &win_rect);

			using info.bmiHeader;
			using win_rect;
			biWidth  = right - left; 
		    biHeight = top - bottom;

		    application.resize(u16(biWidth), u16(-biHeight));

		case WM_PAINT:
			using application;
			using frame_buffer;
			update();

		    SetDIBitsToDevice(
		        win_dc, 0, 0, 
		        DWORD(width), 
		        DWORD(height),
		        0, 0,
		        0, DWORD(height),
		        cast(^u32)pixels,
		        &info,
		        DIB_RGB_COLORS
		    );

		    ValidateRgn(window, nil);


        case WM_DESTROY:
        	application.is_running = false;
        	PostQuitMessage(0);
		case:
			return DefWindowProcA(hWnd, message, wParam, lParam);
	}

	return 0;
}

run_application :: proc() {
	default_context = runtime.default_context();

	HInstance: HINSTANCE = transmute(HINSTANCE)GetModuleHandleA(nil);
	window_class: WNDCLASSA = {
	    lpszClassName  = application.class_name,
	    hInstance      = HInstance,
	    lpfnWndProc    = WndProc,
	    style          = CS_OWNDC|CS_HREDRAW|CS_VREDRAW|CS_DBLCLKS,
	    hCursor        = LoadCursorA(nil, IDC_ARROW)
	};

	result := RegisterClassA(&window_class);
	when ODIN_DEBUG do asset(result != 0, "Failed to register class!");

    window = CreateWindowExA(0, 
    	application.class_name, 
    	"Application", 
    	WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        INITIAL_WIDTH, 
        INITIAL_HEIGHT, 
        nil, nil, HInstance, nil
    );
    when ODIN_DEBUG do assert(window != nil, "Failed to create window!");

    win_dc = GetDC(window);

    ShowWindow(window, SW_SHOWDEFAULT);

    message: MSG;

    for application.is_running {
		for PeekMessageA(&message, nil, 0, 0, PM_REMOVE) {
			TranslateMessage(&message);
            DispatchMessageA(&message);	
		}

		InvalidateRgn(window, nil, false);
    }
}