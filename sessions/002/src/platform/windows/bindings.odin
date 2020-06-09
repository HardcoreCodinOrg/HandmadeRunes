package windows

foreign import kernel "system:kernel32.lib"

@(default_calling_convention = "std")
foreign kernel {
	GetModuleHandleA :: proc(
		lpModuleName: LPCSTR
	) -> HMODULE ---;	
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

