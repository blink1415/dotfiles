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
  CapsLock & t::
  Run "C:\Users\nikol\Desktop\wsl_home"
  return
  CapsLock & p::
  Run "C:\Users\nikol\Desktop\pshell"
  return
  CapsLock & e::
  Run "C:\windows\explorer.exe"
  return
  CapsLock & d::
  SendInput {]}{d}
  return

  ; Scroll lock
  Scrolllock::^!l


