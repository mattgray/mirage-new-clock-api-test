open Lwt

module Main (C: V1_LWT.CONSOLE) (CLOCK: V1.CLOCK) = struct

  let get_time_string_old_api = fun () ->
    CLOCK.time () |>
    Ptime.of_float_s |>
    function
      | Some time -> Ptime.to_rfc3339 ~frac:3 time
      | None -> failwith "Invalid span from CLOCK.time"

  let get_time_string_new_api = fun () ->
    CLOCK.now_d_ps () |>
    Ptime.Span.of_d_ps |>
    Ptime.of_span |>
    function
      | Some time -> Ptime.to_rfc3339 ~frac:3 time
      | None -> failwith "Invalid span from CLOCK.time"

  let start console clock =
    for_lwt i = 0 to 4 do
      lwt () = OS.Time.sleep 1.0 in
      C.log console ( "the time from CLOCK.time is: "^(get_time_string_old_api ())) ;
      C.log console ( "the time from CLOCK.now_d_ps is: "^(get_time_string_new_api ())) ;
      return ()
    done

end
