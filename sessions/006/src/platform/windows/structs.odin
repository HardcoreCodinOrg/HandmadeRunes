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
LPPOINT :: ^POINT;

MSG :: struct {
    hwnd     : HWND,
    message  : UINT,
    wParam   : WPARAM,
    lParam   : LPARAM,
    time     : DWORD,
    pt       : POINT
};
LPMSG :: ^MSG;

RAWINPUTDEVICE :: struct {
    usUsagePage    : USHORT,
    usUsage        : USHORT,
    dwFlags        : DWORD,
    hwndTarget     : HWND
};
PCRAWINPUTDEVICE :: ^RAWINPUTDEVICE;

RAWMOUSE :: struct {
    usFlags: USHORT,
    DUMMYUNIONNAME: struct #raw_union {
        ulButtons: ULONG,
        DUMMYSTRUCTNAME: struct {
            usButtonFlags : USHORT,
            usButtonData  : USHORT
        }
    },
    ulRawButtons       : ULONG,
    lLastX             : LONG,
    lLastY             : LONG,
    ulExtraInformation : ULONG
};

RAWKEYBOARD :: struct {
    MakeCode        : USHORT,
    Flags           : USHORT,    
    Reserved        : USHORT,
    VKey            : USHORT,
    Message         : UINT,
    ExtraInformation: ULONG
};

RAWINPUT :: struct {
    header : RAWINPUTHEADER,
    data   : struct #raw_union {
        mouse    : RAWMOUSE,
        keyboard : RAWKEYBOARD,
        hid      : RAWHID
    }
};
HRAWINPUT__ :: struct {unused: INT};

RAWINPUTHEADER :: struct #packed {
    dwType  : DWORD,
    dwSize  : DWORD,
    hDevice : HANDLE,
    wParam  : WPARAM
};

RAWHID :: struct {
    dwSizeHid : DWORD,    
    dwCount   : DWORD,
    bRawData  : [1]BYTE
};

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

LARGE_INTEGER :: struct #raw_union {
    DUMMYSTRUCTNAME: struct {
        LowPart  : DWORD,
        HighPart : LONG
    },
    u: struct {
        LowPart  : DWORD,
        HighPart : LONG
    },
    QuadPart     : LONGLONG
};