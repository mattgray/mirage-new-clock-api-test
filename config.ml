open Mirage

let main =
  let libraries = ["ptime"; "lwt.ppx"] in
  let packages =  ["ptime"] in
  foreign
    ~libraries ~packages
    "Unikernel.Main" (console @-> clock @-> pclock @-> mclock @-> job)

let () =
  register "console" [
    main
          $ default_console
          $ default_clock
          $ default_posix_clock
          $ default_monotonic_clock
  ]
