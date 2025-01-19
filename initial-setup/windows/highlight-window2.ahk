#Requires AutoHotkey v2.0
#SingleInstance Force

myGui := Gui()
myGui.Opt("+LastFound")
hWnd := WinExist()
DllCall("RegisterShellHookWindow", "UInt", hWnd)
MsgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
OnMessage(MsgNum, ShellMessage)
Persistent

ShellMessage(wParam,lParam, msg, hwnd) {
    if (wParam = 32772){
        SetTimer(DrawActive,-1)
    }
}

DrawActive()
{
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Border Color Configuration
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    border_color := "0xFFFF00"
    ; Start by removing the borders from all windows, since we do not know which window was previously active
    windowHandles := WinGetList(,,,)
    For handle in windowHandles
    {
        DrawBorder(handle, , 0)
    }
    ; Draw the border around the active window
    hwnd := WinExist("A")
    DrawBorder(hwnd, border_color, 1)
}

DrawBorder(hwnd, color:=0xFF0000, enable:=1) {
    static DWMWA_BORDER_COLOR := 34
    static DWMWA_COLOR_DEFAULT	:= 0xFFFFFFFF
    R := (color & 0xFF0000) >> 16
    G := (color & 0xFF00) >> 8
    B := (color & 0xFF)
    color := (B << 16) | (G << 8) | R
    DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", DWMWA_BORDER_COLOR, "int*", enable ? color : DWMWA_COLOR_DEFAULT, "int", 4)
}
