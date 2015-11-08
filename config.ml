open Mirage

let main =
  let libraries = ["ptime"] in
  let packages =  ["ptime"] in
  foreign
    ~libraries ~packages
    "Unikernel.Main" (console @-> clock @-> pclock @-> job)

let () =
  register "console" [
    main $ default_console $ default_clock $ default_posix_clock
  ]
