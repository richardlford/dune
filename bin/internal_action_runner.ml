open Stdune
open Import

let run =
  let+ common = Common.term
  and+ name =
    Arg.(required & pos 0 (some string) None (Arg.info [] ~docv:"NAME"))
  in
  let common = Common.forbid_builds common in
  let config = Common.init common in
  Scheduler.go ~common ~config @@ fun () ->
  let where =
    match Dune_rpc.Where.of_env Env.initial with
    | Ok s -> s
    | Error `Missing ->
      User_error.raise
        [ Pp.textf "must set the environment variable %s" Dune_rpc.Where.env_var
        ]
    | Error (`Exn exn) ->
      (* TODO include actual value *)
      User_error.raise
        [ Pp.textf "the environment variable %s is invalid"
            Dune_rpc.Where.env_var
        ; Exn.pp exn
        ]
  in
  Dune_engine.Action_runner.Worker.start ~name ~where

let command = Cmd.v (Cmd.info "action-runner") run
