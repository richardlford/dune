open Import

module Stanzas_to_entries : sig
  val stanzas_to_entries :
    Super_context.t -> Install.Entry.Sourced.t list Package.Name.Map.t Memo.t
end

val install_file :
  package:Package.Name.t -> findlib_toolchain:Context_name.t option -> string

val symlink_rules :
  Super_context.t -> dir:Path.Build.t -> (Subdir_set.t * Rules.t) Memo.t

(** Generate rules for [.dune-package], [META.<package-name>] files. and
    [<package-name>.install] files. *)
val gen_project_rules : Super_context.t -> Dune_project.t -> unit Memo.t

module Build_path_prefix_map_dyn : sig
  val pair_to_dyn : Build_path_prefix_map.pair -> Dyn.t
  val to_dyn : Build_path_prefix_map.map -> Dyn.t
end

module Build_map : sig
  type t = Build_path_prefix_map.map String.Map.t
  val to_dyn : t -> Dyn.t
  val build_all_maps_full : Super_context.t Context_name.Map.t -> 
    Build_path_prefix_map.map String.Map.t Memo.t
  val build_tree_dyn : Super_context.t Context_name.Map.t -> Dyn.t Memo.t
  val build_all_maps : Super_context.t Context_name.Map.t -> 
    Build_path_prefix_map.map String.Map.t Memo.t
end
