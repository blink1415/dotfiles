#InstallKeybdHook
 
SetCapslockState, AlwaysOff
SetScrolllockState, AlwaysOff
 
;cursor
; Caps lock
CapsLock & h::
SendInput {Left}
return
CapsLock & j::
SendInput {Down}
return
CapsLock & k::
SendInput {Up}
return
CapsLock & l::
SendInput {Right}
return

; Scroll lock
Scrolllock::^!l
