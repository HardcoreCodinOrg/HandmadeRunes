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
}

