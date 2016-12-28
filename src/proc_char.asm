; ---------------------------------
; @module ProcChar
; define WM_CHAR handler
; ---------------------------------
include stdafx.inc
include images.inc

extrn status: dword

.code
ProcChar proc hWnd, uMsg, wParam, lParam
    local @stRect: RECT
   .if wParam == 032H
      mov eax, hBitmapBG1
      mov hBitmapBG, eax
      mov status,2
      invoke GetClientRect, hWnd, addr @stRect
      invoke InvalidateRect, hWnd, addr @stRect, TRUE
      invoke UpdateWindow, hWnd
   .endif

   .if wParam == 033H
      mov eax, hBitmapBG1
      mov hBitmapBG, eax
      mov status,3
   .endif

   .if wParam == 034H
      mov eax, hBitmapBG1
      mov hBitmapBG, eax
      mov status,4
   .endif

   .if wParam == 035H
    mov eax, hBitmapBG3
    mov hBitmapBG, eax
    mov status,5
  .endif

   ret
ProcChar endp

end