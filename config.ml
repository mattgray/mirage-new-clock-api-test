open Mirage

let main = foreign "Unikernel.Main" (console @-> clock @-> job)

let () =
  register "console" [
    main $ default_console $ default_clock
  ]
