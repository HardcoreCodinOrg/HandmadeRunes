package windows

import "../../application"

WndProc:: proc "std" (
	hWnd: HWND, 
	message: UINT, 
	wParam: WPARAM, 
	lParam: LPARAM
) -> LRESULT {

	switch message {
        case WM_DESTROY:
        	application.is_running = false;
        	PostQuitMessage(0);
		case:
			return DefWindowProcA(hWnd, message, wParam, lParam);
	}

	return 0;
}

run_application :: proc() {
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

    window := CreateWindowExA(0, 
    	application.class_name, 
    	"Application", 
    	WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        500, 400, 
        nil, nil, HInstance, nil
    );
    when ODIN_DEBUG do assert(window != nil, "Failed to create window!");

    ShowWindow(window, SW_SHOWDEFAULT);

    message: MSG;

    for application.is_running {
		for PeekMessageA(&message, nil, 0, 0, PM_REMOVE) {
			TranslateMessage(&message);
            DispatchMessageA(&message);	
		}
    }
}