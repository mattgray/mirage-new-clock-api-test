open Lwt

module Main (C: V1_LWT.CONSOLE) (CLOCK: V1.CLOCK) (PCLOCK: V1.PCLOCK) = struct

  let get_time_string_old_api = fun () ->
    CLOCK.time () |>
    Ptime.of_float_s |>
    function
      | Some time -> Ptime.to_rfc3339 ~frac:3 time
      | None -> failwith "Invalid span from CLOCK.time"

  let get_time_string_new_api = fun () ->
    PCLOCK.now_d_ps () |>
    Ptime.Span.of_d_ps |>
    Ptime.of_span |>
    function
      | Some time -> Ptime.to_rfc3339 ~frac:3 time
      | None -> failwith "Invalid span from PCLOCK.now_d_ps"

  let start console clock pclock =
    let log = C.log console in
    for_lwt i = 0 to 4 do
      lwt () = OS.Time.sleep 1.0 in
      log (Printf.sprintf "the utc time from CLOCK.time is: %s"
        (get_time_string_old_api ()));
      log (Printf.sprintf "the utc time from PCLOCK.now_d_ps is: %s"
        (get_time_string_new_api ()));
      match PCLOCK.current_tz_offset_s () with
        | Some offset ->
            return @@ log (Printf.sprintf "the local time offset from UTC (PCLOCK.current_tz_offset_s) is: %d" offset)
        | None -> log "Clock local time offset unavailable";
      match PCLOCK.period_d_ps () with
        | Some (d, ps) -> return (
          log ( Printf.sprintf "the period of the clock (PCLOCK.period_d_ps) is: %d days %Ld ps" d ps))
        | None -> return (log "Clock period unavailable")
    done
end
