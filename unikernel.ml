open Lwt

module Main (C: V1_LWT.CONSOLE) (CLOCK: V1.CLOCK) = struct

  let get_time_string = fun () ->
    CLOCK.time () |>
    Ptime.of_float_s |> function
      | Some time -> Ptime.to_rfc3339 ~frac:3 time
      | None -> failwith "Invalid span from CLOCK.time"

  let start console clock =
    for_lwt i = 0 to 4 do
      lwt () = OS.Time.sleep 1.0 in
      C.log console ( "the time is "^ (get_time_string ())) ;
      return ()
    done

end
