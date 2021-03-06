(** 
   Representation of a trainer and their data. 
*)

open Pokemon
open Yojson.Basic.Util

(** The type of values representing a trainer. *)
type trainer = {
  name : string;
  catchphrase : string list;
  endphrase: string list;
  x : int;
  y : int;
  poke_list : Pokemon.pokemon list;
}

(** [trainer_from_json j] is the trainer represented by [j]. *)
let trainer_from_json j = 
  {
    name = j |> member "name" |> to_string;
    catchphrase = j |> member "catchphrase" |> to_list |> List.map to_string;
    endphrase = j |> member "endphrase" |> to_list |> List.map to_string;
    x = j |> member "x" |> to_int;
    y = j |> member "y" |> to_int;
    poke_list = j |> member "poke_list" |> Pokemon.poke_list_from_json;
  } 

(** [trainer_list_from_json j] is a list of trainers from the JSON [j].
    Requires: [j] is a valid JSON for a list of trainers. *)
let trainer_list_from_json j = j |> to_list |> List.map trainer_from_json
