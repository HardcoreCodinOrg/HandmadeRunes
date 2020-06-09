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

RGBQUAD :: struct {
  rgbBlue, rgbGreen, rgbRed, rgbReserved: BYTE
};

BITMAPINFOHEADER :: struct {
    biSize          : DWORD,
    biWidth         : LONG,
    biHeight        : LONG,
    biPlanes        : WORD,
    biBitCount      : WORD,
    biCompression   : DWORD,
    biSizeImage     : DWORD,
    biXPelsPerMeter : LONG,
    biYPelsPerMeter : LONG,
    biClrUsed       : DWORD,
    biClrImportant  : DWORD
};

BITMAPINFO :: struct {
    bmiHeader : BITMAPINFOHEADER,
    bmiColors : [1]RGBQUAD
};

RECT :: struct {
    left, top, right, bottom: LONG
}
LPRECT :: ^RECT;