package windows


WNDPROC   :: distinct #type proc "std" (HWND, UINT, WPARAM, LPARAM) -> LRESULT;

LOWORD :: proc(dwValue: DWORD) -> WORD {
    return WORD(
                uintptr(
                        int(
                            uintptr(
                                    DWORD_PTR(
                                                uintptr(dwValue)
                                              )
                                    )
                            ) & 0xffff
                        )
            );    
}

HIWORD :: proc(dwValue: DWORD) -> WORD {
    return WORD(
                uintptr(
                            (
                                int(
                                    uintptr(
                                            DWORD_PTR(
                                                        uintptr(dwValue)
                                                     )
                                            )
                                    ) >> 16
                            ) & 0xffff
                        )
                );
}

GET_X_LPARAM :: proc(lp: LPARAM) -> INT {
    return INT(SHORT(LOWORD(DWORD(lp))));
}

GET_Y_LPARAM :: proc(wp: LPARAM) -> INT {
    return INT(SHORT(HIWORD(DWORD(wp))));
}

GET_WHEEL_DELTA_WPARAM :: proc(wParam: WPARAM) -> SHORT {
    return SHORT(HIWORD(DWORD(wParam)));
}