open Mirage

let main = foreign "Unikernel.Main" (console @-> clock @-> job)


let () =
  add_to_opam_packages ["ptime"];
  add_to_ocamlfind_libraries ["ptime"];

  register "console" [
    main $ default_console $ default_clock
  ]
