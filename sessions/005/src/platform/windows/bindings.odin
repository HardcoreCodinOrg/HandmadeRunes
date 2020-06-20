package windows

foreign import kernel "system:kernel32.lib"

@(default_calling_convention = "std")
foreign kernel {
	GetModuleHandleA :: proc(
		lpModuleName: LPCSTR
	) -> HMODULE ---;	

    QueryPerformanceCounter :: proc(
        lpPerformanceCount: ^LARGE_INTEGER
    ) -> BOOL ---;

    QueryPerformanceFrequency :: proc(
        lpFrequency: ^LARGE_INTEGER
    ) -> BOOL ---;
}

foreign import user "system:user32.lib"

@(default_calling_convention = "std")
foreign user {
	LoadCursorA :: proc(
		hInstance    : HINSTANCE,
		lpCursorName : LPSTR
	) -> HCURSOR ---;

	RegisterClassA :: proc(
		lpWndClass: ^WNDCLASSA
	) -> ATOM ---;

    CreateWindowExA :: proc(
        dwExStyle    : DWORD,
        lpClassName  : LPCSTR,
        lpWindowName : LPCSTR,
        dwStyle      : DWORD,
        X            : INT,
        Y            : INT,
        nWidth       : INT,
        nHeight      : INT,
        hWndParent   : HWND,
        hMenu        : HMENU,
        hInstance    : HINSTANCE,
        lpParam      : LPVOID
    ) -> HWND ---;

    ShowWindow :: proc(
        hWnd    : HWND,
        nCmdShow: INT
    ) -> BOOL ---;

    DefWindowProcA :: proc(
        hWnd   : HWND,
        Msg    : UINT,
        wParam : WPARAM,
        lParam : LPARAM
    ) -> LRESULT ---;

    PeekMessageA :: proc(
        lpMsg         : LPMSG,
        hWnd          : HWND,
        wMsgFilterMin : UINT,
        wMsgFilterMax : UINT,
        wRemoveMsg    : UINT
    ) -> BOOL ---;

	TranslateMessage :: proc(
        lpMsg: ^MSG
    ) -> BOOL ---;

    DispatchMessageA :: proc(
        msg: ^MSG
    ) -> LRESULT ---;

    PostQuitMessage :: proc(nExitCode: INT) ---;    

    GetDC :: proc(
      hWnd: HWND
    ) -> HDC ---;


    GetClientRect :: proc(
        hWnd   : HWND,
        lpRect : LPRECT
    ) -> BOOL ---;

    ValidateRgn :: proc(
        hWnd: HWND,
        hRgn: HRGN
    ) -> BOOL ---;

    InvalidateRgn :: proc(
      hWnd  : HWND,
      hRgn  : HRGN,
      bErase: BOOL
    ) -> BOOL ---;
    
    GetCursorPos :: proc(
        lpPoint: LPPOINT
    ) -> BOOL ---;

    SetCapture :: proc(hWnd: HWND) -> HWND ---;
    ReleaseCapture :: proc() -> BOOL ---;
    ShowCursor :: proc(bShow: BOOL) ---;

    RegisterRawInputDevices :: proc(
        pRawInputDevices : PCRAWINPUTDEVICE,
        uiNumDevices     : UINT,
        cbSize           : UINT
    ) -> BOOL ---;

    GetRawInputData :: proc(
        hRawInput   : HRAWINPUT,
        uiCommand   : UINT,
        pData       : LPVOID,
        pcbSize     : PUINT,
        cbSizeHeader: UINT
    ) -> UINT ---;
}

foreign import gdi "system:gdi32.lib"

@(default_calling_convention = "std")
foreign gdi {
    SetDIBitsToDevice :: proc(
        hdc       : HDC,
        xDest     : int,
        yDest     : int,
        w         : DWORD,
        h         : DWORD,
        xSrc      : int,
        ySrc      : int,
        StartScan : UINT,
        cLines    : UINT,
        lpvBits   : rawptr,
        lpbmi     : ^BITMAPINFO,
        ColorUse  : UINT
    ) -> int ---;
}

LOWORD :: inline proc(dwValue: DWORD) ->  WORD do return WORD(uintptr( int(uintptr(DWORD_PTR(uintptr(dwValue))))        & 0xffff));
HIWORD :: inline proc(dwValue: DWORD) ->  WORD do return WORD(uintptr((int(uintptr(DWORD_PTR(uintptr(dwValue)))) >> 16) & 0xffff));
GET_X_LPARAM :: inline proc(lp: LPARAM) -> INT do return INT(SHORT(LOWORD(DWORD(lp))));
GET_Y_LPARAM :: inline proc(wp: LPARAM) -> INT do return INT(SHORT(HIWORD(DWORD(wp))));
GET_WHEEL_DELTA_WPARAM :: inline proc(wParam: WPARAM) -> SHORT do return SHORT(HIWORD(DWORD(wParam)));