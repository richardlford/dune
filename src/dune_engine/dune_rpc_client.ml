module Dune_rpc = Dune_rpc_private

module Private = struct
  module Fiber = struct
    include Fiber

    let parallel_iter t ~f =
      let stream = Fiber.Stream.In.create t in
      Fiber.Stream.In.parallel_iter stream ~f
  end
end

include Dune_rpc.Client.Make (Private.Fiber) (Csexp_rpc.Session)

module Where = struct
  open Stdune

  let to_socket = function
    | `Unix p -> Unix.ADDR_UNIX p
    | `Ip (`Host host, `Port port) ->
      Unix.ADDR_INET (Unix.inet_addr_of_string host, port)

  let to_string = function
    | `Unix p -> sprintf "unix://%s" p
    | `Ip (`Host host, `Port port) -> sprintf "%s:%d" host port
end

open Stdune
open Fiber.O

type chan = Csexp_rpc.Session.t

module Connection = struct
  type t = Csexp_rpc.Session.t

  let connect where =
    let sock = Where.to_socket where in
    let* client = Csexp_rpc.Client.create sock in
    let+ res = Csexp_rpc.Client.connect client in
    match res with
    | Ok s -> Ok s
    | Error exn ->
      Error
        (User_error.make
           [ Pp.textf "failed to connect to RPC server %s"
               (Where.to_string where)
           ; Exn_with_backtrace.pp exn
           ])

  let connect_exn where =
    let+ conn = connect where in
    match conn with
    | Ok s -> s
    | Error msg -> raise (User_error.E msg)
end

let client ?handler ~private_menu connection init ~f =
  let f client =
    Fiber.finalize
      (fun () -> f client)
      ~finally:(fun () -> Csexp_rpc.Session.write connection None)
  in
  connect_with_menu ?handler ~private_menu connection init ~f
