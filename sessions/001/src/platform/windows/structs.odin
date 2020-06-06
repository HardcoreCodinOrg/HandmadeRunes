package windows

WNDCLASSA :: struct {
    style         : UINT,
    lpfnWndProc   : WNDPROC,
    cbClsExtra    : INT,
    cbWndExtra    : INT,
    hInstance     : HINSTANCE,
    hIcon         : HICON,
    hCursor       : HCURSOR,
    hbrBackground : HBRUSH,
    lpszMenuName  : LPCSTR,
    lpszClassName : LPCSTR
};

POINT ::struct {
    x, y: LONG
};

MSG :: struct {
    hwnd     : HWND,
    message  : UINT,
    wParam   : WPARAM,
    lParam   : LPARAM,
    time     : DWORD,
    pt       : POINT
};
LPMSG :: ^MSG;