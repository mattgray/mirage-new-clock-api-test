open Lwt

module Main (C: V1_LWT.CONSOLE) (CLOCK: V1.CLOCK) = struct

  let get_time_string = fun clock ->
    CLOCK.time clock |> string_of_float

  let start console clock =
    for_lwt i = 0 to 4 do
      lwt () = OS.Time.sleep 1.0 in
      C.log console ( "the time is "^ (get_time_string clock)) ;
      return ()
    done

end
