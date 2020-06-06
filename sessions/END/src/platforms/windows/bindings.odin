package windows

foreign import user "system:user32.lib"

@(default_calling_convention = "std")
foreign user {
    RegisterClassA :: proc(
        lpWndClass: ^WNDCLASSA
    ) -> WORD ---;

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

    LoadCursorA :: proc(
        hInstance    : HINSTANCE,
        lpCursorName : LPSTR
    ) -> HCURSOR ---;

    ShowWindow :: proc(
        hWnd: HWND,
        nCmdShow: INT
    ) -> BOOL ---;

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
    DefWindowProcA :: proc(
        hWnd   : HWND,
        Msg    : UINT,
        wParam : WPARAM,
        lParam : LPARAM
    ) -> LRESULT ---;

    GetDC :: proc(
        hWnd: HWND
    ) -> HDC ---;

    GetClientRect :: proc(
        hWnd   : HWND,
        lpRect : LPRECT
    ) -> BOOL ---;

    ValidateRgn :: proc(
        hWnd    : HWND,
        hRgn    : HRGN
    ) -> BOOL ---;

    InvalidateRgn :: proc(
        hWnd    : HWND,
        hRgn    : HRGN,
        bErase  : BOOL
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


foreign import kernel "system:kernel32.lib"

@(default_calling_convention = "std")
foreign kernel {
    GetModuleHandleA :: proc(
        module_name: cstring
    ) -> HMODULE ---;

    QueryPerformanceFrequency :: proc(
        lpFrequency: ^LARGE_INTEGER
    ) -> BOOL ---;

    QueryPerformanceCounter :: proc(
        lpPerformanceCount: ^LARGE_INTEGER
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
