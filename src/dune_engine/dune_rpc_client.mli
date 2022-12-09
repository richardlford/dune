(** move this to its own library once we untangle the dependency with Scheduler *)

module Dune_rpc := Dune_rpc_private

include Dune_rpc.Client.S with type 'a fiber := 'a Fiber.t

module Connection : sig
  type t

  (** like [connect] but fails with a nice error message for the user *)
  val connect_exn : Dune_rpc.Where.t -> t Fiber.t
end

(** [client t where init ~on_notification ~f] Establishes a client connection to
    [where], initializes it with [init]. Once initialization is done, cals [f]
    with the active client. All notifications are fed to [on_notification]*)
val client :
     ?handler:Handler.t
  -> private_menu:proc list
  -> Connection.t
  -> Dune_rpc.Initialize.Request.t
  -> f:(t -> 'a Fiber.t)
  -> 'a Fiber.t
