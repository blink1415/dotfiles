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
CapsLock & a::
SendInput {Ctrl down}{a}{Ctrl up}
return

; Scroll lock
Scrolllock::^!l

