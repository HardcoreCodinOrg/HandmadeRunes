package windows

MSG :: struct {
    hwnd     : HWND,
    message  : UINT,
    wParam   : WPARAM,
    lParam   : LPARAM,
    time     : DWORD,
    pt       : POINT
};
LPMSG :: ^MSG;

WNDCLASSA :: struct {
    style         : UINT,
    lpfnWndProc   : WNDPROC,
    cbClsExtra    : INT,
    cbWndExtra    : INT,
    hInstance     : HINSTANCE,
    hIcon         : HICON,
    hCursor       : HCURSOR,
    hbrBackground : HBRUSH,
    lpszMenuName  : cstring,
    lpszClassName : cstring
};

POINT ::struct {
    x, y: LONG
};


RECT :: struct {
    left   : LONG,
    top    : LONG,
    right  : LONG,
    bottom : LONG,
};
LPRECT :: ^RECT;

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

RGBQUAD :: struct {
    rgbBlue     : BYTE,
    rgbGreen    : BYTE,
    rgbRed      : BYTE,
    rgbReserved : BYTE
};

BITMAPINFO :: struct {
    bmiHeader : BITMAPINFOHEADER,
    bmiColors : [1]RGBQUAD
};

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
RAWHID :: struct {
    dwSizeHid : DWORD,    
    dwCount   : DWORD,
    bRawData  : [1]BYTE
};

RAWINPUTDEVICE :: struct {
    usUsagePage    : USHORT,
    usUsage        : USHORT,
    dwFlags        : DWORD,
    hwndTarget     : HWND
};
PCRAWINPUTDEVICE :: ^RAWINPUTDEVICE;

RAWKEYBOARD :: struct {
    MakeCode        : USHORT,
    Flags           : USHORT,    
    Reserved        : USHORT,
    VKey            : USHORT,
    Message         : UINT,
    ExtraInformation: ULONG
};

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

NTSTATUS  :: struct #packed {
    dwType  : DWORD,
    dwSize  : DWORD,
    hDevice : HANDLE,
    wParam  : WPARAM
};