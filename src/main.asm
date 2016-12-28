include stdafx.inc
include images.inc
include proc_char.inc

mRepeat macro dPosX
  mov eax, dPosX
  add eax,156
  sub edx,edx
  div mov_width
  sub edx,156
  mov dPosX, edx
endm

mAddText macro textName, dPosX, dPosY
  mov eax, dPosX
  mov ebx, dPosY
  add eax, 25
  mov @stRectWord.left, eax
  add ebx, 33
  mov @stRectWord.top, ebx
  add ebx, 10
  mov @stRectWord.bottom, ebx
  add eax, 105
  mov @stRectWord.right, eax
  invoke DrawText, @hDc, addr textName, -1, addr @stRectWord, DT_SINGLELINE or DT_CENTER or DT_VCENTER
endm

mAddFrog macro dPosX, dPosY
  mov eax, dPosX
  add eax, 35
  mov @dPosFrog, eax
  mov ebx, dPosY
  sub ebx, 25
  invoke CreateCompatibleDC, @hDc
  mov @hDcFrog, eax ; Frog DC
  invoke SelectObject, @hDcFrog, hBitmapFrog
  invoke TransparentBlt, @hDc, @dPosFrog, ebx, 75, 55, @hDcFrog, 0, 0, 75, 55, 0ffffffh
endm


.data
HeroPosX dd 0
HeroPosY dd 0
HeroHealth dd 1000
HeroAttack dd 100
HeroDefence dd 100
HeroMoney dd 0
dPosX1 dd -80
dPosX2 dd -80
dPosX3 dd -80
dPosY1 dd 415
dPosY2 dd 325
dPosY3 dd 235
status dd 0
mov_width dd 810+156
.data?
public status

hInstance dd  ?
hWinMain dd  ?
hBitmapHero dd ?

hIcon dd ?
hMenu dd ?
.const
szIcon db 'images\\icon.ico', 0
szBitmapTile db 'images\\tile.bmp', 0
szBitmapHero db 'images\\hero.bmp', 0

szClassName db 'MainWindow', 0
szMenuNewGame db '����Ϸ(&N)', 0
szMenuQuit db '�˳�(&Q)', 0
szCaptionMain db '�����½�', 0
szHeroHealth db '����', 0
szHeroAttack db '������', 0
szText db 'sometimes naive', 0
words db 'a','b','c','d','e',0

.code



ProcTimer proc hWnd, uMsg, idEvent, dwTime
  local @stRect: RECT
  .if status != 0

  mov eax, dPosX1
  mov ebx, dPosY1
  mov @stRect.left, 0
  add eax, 160
  mov @stRect.right, 810
  sub ebx, 25
  mov @stRect.top, 0
  add ebx, 92
  mov @stRect.bottom, ebx
  add dPosX1,8
  add dPosX2,9
  add dPosX3,10

  push dPosX1
  mRepeat dPosX1
  pop ecx
  .if ecx < dPosX1 && status==2
    sub status,1
    invoke GetClientRect, hWnd, addr @stRect
    invoke InvalidateRect, hWnd, addr @stRect, TRUE
    invoke UpdateWindow, hWnd
  .endif

  push dPosX2
  mRepeat dPosX2
  pop ecx
  .if ecx < dPosX2 && status==3
    sub status,1
  .endif

  push dPosX3
  mRepeat dPosX3
  pop ecx
  .if ecx < dPosX3 && status==4
    sub status,1
  .endif

  invoke InvalidateRect, hWnd, addr @stRect, TRUE
  invoke UpdateWindow, hWnd
  .endif

ProcTimer endp




ProcKeydown proc hWnd, uMsg, wParam, lParam
  local @stRect: RECT
  .if wParam >= 041H && wParam <= 05AH

  .endif
  .if wParam == VK_RETURN
    mov eax, hBitmapBG2
    mov hBitmapBG, eax
    mov status,1
  .endif

  .if wParam == VK_DELETE
    mov eax, hBitmapBG1
    mov hBitmapBG, eax
    mov status,2
  .endif

  .if wParam == VK_INSERT
    mov eax, hBitmapBG3
    mov hBitmapBG, eax
    mov status,1
  .endif

  invoke GetClientRect, hWnd, addr @stRect
  invoke InvalidateRect, hWnd, addr @stRect, TRUE
  invoke UpdateWindow, hWnd
  ret
ProcKeydown endp

_ProcWinMain proc uses ebx edi esi hWnd, uMsg, wParam, lParam
  local @stPs: PAINTSTRUCT
  local @stRect: RECT
  local @stRectWord:RECT
  local @hDc
  local @hBMP
  local @hDcBG
  local @hDcLeaf
  local @hDcLeaf2
  local @hDcLeaf3
  local @hDcFrog
  local @dPosFrog

  mov eax, uMsg
  ; PrintHex eax
  .if eax == WM_PAINT
    invoke BeginPaint, hWnd, addr @stPs
    mov @hDc, eax
    
    invoke CreateCompatibleDC, @hDc
    mov @hDcBG, eax ; Background DC
    invoke SelectObject, @hDcBG, hBitmapBG
    invoke BitBlt, @hDc, 0, 0, 800, 670, @hDcBG, 0, 0, SRCCOPY
    invoke DeleteDC, @hDcBG
    mov eax, hBitmapBG

    
    
    .if status == 1
      ;add leaf
      mov eax, hBitmapBG2
      mov hBitmapBG, eax

      invoke CreateCompatibleDC, @hDc
      mov @hDcLeaf, eax ; Leaf DC
      invoke SelectObject, @hDcLeaf, hBitmapLeaf
      invoke TransparentBlt, @hDc, dPosX1, dPosY1, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, dPosX2, dPosY2, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, dPosX3, dPosY3, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh

      mAddText words[1], dPosX1, dPosY1
      mAddText words[2], dPosX2, dPosY2
      mAddText szText, dPosX3, dPosY3

      invoke DeleteDC, @hDcLeaf
      invoke DeleteDC, @hDcFrog
    .endif


    .if status == 2
      ;add leaf
      mov eax, hBitmapBG1
      mov hBitmapBG, eax

      invoke CreateCompatibleDC, @hDc
      mov @hDcLeaf, eax ; Leaf DC
      invoke SelectObject, @hDcLeaf, hBitmapLeaf
      invoke TransparentBlt, @hDc, dPosX1, dPosY1, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, dPosX2, dPosY2, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, dPosX3, dPosY3, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      mAddText szText, dPosX1, dPosY1
      mAddText szText, dPosX2, dPosY2
      mAddText szText, dPosX3, dPosY3      

      mAddFrog dPosX1, dPosY1

      invoke DeleteDC, @hDcLeaf

      invoke DeleteDC, @hDcFrog
    .endif

    .if status == 3
      ;add leaf
      invoke CreateCompatibleDC, @hDc
      mov @hDcLeaf, eax ; Leaf DC
      invoke SelectObject, @hDcLeaf, hBitmapLeaf
      invoke TransparentBlt, @hDc, dPosX1, dPosY1, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, dPosX2, dPosY2, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, dPosX3, dPosY3, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      mAddText szText, dPosX1, dPosY1
      mAddText szText, dPosX2, dPosY2
      mAddText szText, dPosX3, dPosY3      

      mAddFrog dPosX2, dPosY2

      invoke DeleteDC, @hDcLeaf
      invoke DeleteDC, @hDcFrog
    .endif

    .if status == 4
      ;add leaf
      invoke CreateCompatibleDC, @hDc
      mov @hDcLeaf, eax ; Leaf DC
      invoke SelectObject, @hDcLeaf, hBitmapLeaf
      invoke TransparentBlt, @hDc, dPosX1, dPosY1, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, dPosX2, dPosY2, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, dPosX3, dPosY3, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      mAddText szText, dPosX1, dPosY1
      mAddText szText, dPosX2, dPosY2
      mAddText szText, dPosX3, dPosY3      

      mAddFrog dPosX3, dPosY3

      invoke DeleteDC, @hDcLeaf
      invoke DeleteDC, @hDcFrog
    .endif

      .if status == 5
      ;add leaf
      invoke CreateCompatibleDC, @hDc
      mov @hDcLeaf, eax ; Leaf DC
      invoke SelectObject, @hDcLeaf, hBitmapLeaf
      invoke TransparentBlt, @hDc, dPosX1, dPosY1, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, dPosX2, dPosY2, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, dPosX3, dPosY3, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      mAddText szText, dPosX1, dPosY1
      mAddText szText, dPosX2, dPosY2
      mAddText szText, dPosX3, dPosY3      

      invoke DeleteDC, @hDcLeaf
      invoke DeleteDC, @hDcFrog
    .endif

    ;invoke DrawText, @hDc, addr szText, -1, addr @stRect, DT_SINGLELINE or DT_CENTER or DT_VCENTER

    invoke EndPaint, hWnd, addr @stPs
  .elseif eax == WM_KEYDOWN
    invoke ProcKeydown, hWnd, uMsg, wParam, lParam
  .elseif eax == WM_CHAR
    invoke ProcChar, hWnd, uMsg, wParam, lParam
  .elseif eax == WM_CREATE
    ; do nothing
  .elseif eax == WM_CLOSE
    invoke DestroyWindow, hWinMain
    invoke PostQuitMessage, NULL
  .elseif eax == WM_COMMAND
    .if wParam == IDM_NEWGAME
      invoke MessageBox, hWinMain, addr szHeroHealth, addr szHeroAttack, MB_OK
    .elseif wParam == IDM_QUIT
      invoke PostQuitMessage, 0
    .endif
  .else
    ; default process
    invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    ret
  .endif
  xor eax, eax
  ret
_ProcWinMain endp

_WinMain proc
  local @stWndClass: WNDCLASSEX
  local @stMsg: MSG
  local @hMenu: HMENU
  local @hIcon: HICON
  invoke GetModuleHandle, NULL
  mov hInstance, eax
  mov @stWndClass.hInstance, eax
  invoke RtlZeroMemory, addr @stWndClass, sizeof @stWndClass 
  mov @stWndClass.hIcon, eax
  mov @stWndClass.hIconSm, eax

  invoke LoadCursor, 0, IDC_ARROW
  mov @stWndClass.hCursor, eax ; ��LoadCursorΪ�������ֵ
  
  mov @stWndClass.cbSize, sizeof WNDCLASSEX
  mov @stWndClass.style, CS_HREDRAW or CS_VREDRAW
  mov @stWndClass.lpfnWndProc, offset _ProcWinMain
  mov @stWndClass.hbrBackground, COLOR_WINDOW + 1
  mov @stWndClass.lpszClassName, offset szClassName

  invoke CreateMenu
  mov hMenu, eax
  invoke AppendMenu, hMenu, 0, IDM_NEWGAME, offset szMenuNewGame
  invoke AppendMenu, hMenu, 0, IDM_QUIT, offset szMenuQuit

  invoke LoadMenu, hInstance, IDM_MAIN
  mov @hMenu, eax

  invoke RegisterClassEx, addr @stWndClass
  ; create a client edged window
  ; whose class is 'szClassName',
  ; and caption is 'szCaptionMain'
  ;  
  invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr szClassName, addr szCaptionMain, WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU, 0, 0, 810, 670+50, NULL, hMenu, hInstance, NULL
  mov hWinMain, eax ; mark hWinMain as the main window
  invoke SetTimer, hWinMain, 0, 100, ProcTimer
  invoke UpdateWindow, hWinMain ; send WM_PRINT to hWinMain
  invoke SendMessage, hWinMain, WM_SETICON, ICON_BIG, hIcon
  invoke ShowWindow, hWinMain, SW_SHOWNORMAL ; show window in a normal way
  ; main loop
  .while 1
    invoke GetMessage, addr @stMsg, NULL, 0, 0
    .break .if eax == 0 ; WM_QUIT => eax == 0
    invoke TranslateMessage, addr @stMsg
    invoke DispatchMessage, addr @stMsg
  .endw
  ret
_WinMain endp


__main proc
  call ImagesInit
  invoke _WinMain
  invoke ExitProcess, 0
__main endp
end __main