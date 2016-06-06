open Lwt

module Main
  (C: V1_LWT.CONSOLE)
  (CLOCK: V1.CLOCK)
  (PCLOCK: V1.PCLOCK)
  (MCLOCK: V1.MCLOCK) = struct

  let clock_rfc3339 () =
    CLOCK.time () |>
    Ptime.of_float_s |>
    function
      | Some time -> Ptime.to_rfc3339 ~frac_s:3 time
        |> Printf.sprintf "RFC3339 CLOCK.time: %s"
      | None -> failwith "Invalid span from CLOCK.time"

  let pclock_rfc3339 () =
    PCLOCK.now_d_ps () |>
    Ptime.Span.unsafe_of_d_ps |>
    Ptime.of_span |>
    function
      | Some time -> Ptime.to_rfc3339 ~frac_s:3 time
        |> Printf.sprintf "RFC3339 PCLOCK.now_d_ps: %s"
      | None -> failwith "Invalid span from PCLOCK.now_d_ps"

  let pclock_offset () =
    PCLOCK.current_tz_offset_s () |> function
      | Some offset -> Printf.sprintf "PCLOCK.current_tz_offset_s = %d" offset
      | None -> "PCLOCK.current_tz_offset_s = None"

  let pclock_period () =
    PCLOCK.period_d_ps () |>
    function
      | Some (d, ps) ->
          Printf.sprintf "PCLOCK.period_d_ps (days, picoseconds) = (%d, %Ld)" d ps
      | None -> "PCLOCK.period_d_ps = None"

  let mclock_elapsed () =
    MCLOCK.elapsed_ns () |>
    Printf.sprintf "MCLOCK.elapsed_ns () = %Ld"

  let checks = [
    clock_rfc3339;
    pclock_rfc3339;
    pclock_offset;
    pclock_period;
    mclock_elapsed
  ]

  let start console clock pclock mclock =
    let log f = C.log console (f ()) in
    for%lwt i = 0 to 4 do
      let%lwt _ = OS.Time.sleep 1.0 in
      List.iter log checks;
      Lwt.return_unit;
    done
end
