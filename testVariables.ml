(** 
   Variables for testing.
*)
open Pokemon

(* Pokemon module test variables. *)

(* The following create the testing pokemon. *)

let starter_pokemon = 
  poke_list_from_json (Yojson.Basic.from_file "starter_pokemon.json")
let grass_pokemon = 
  poke_list_from_json (Yojson.Basic.from_file "grass_pokemon.json")
let water_pokemon = 
  poke_list_from_json (Yojson.Basic.from_file "water_pokemon.json")

let generate_test_pkm pkm_lst index = 
  List.nth pkm_lst index
(** [test_starter_pkm] is bulbasaur in [starter_pokemon.json] *)
let test_starter_pkm = generate_test_pkm starter_pokemon 0
(** [test_grass_pkm] is charmander in [grass_pokemon.json] *)
let test_grass_pkm = generate_test_pkm grass_pokemon 1
(** [test_water_pkm] is squirtle in [water_pokemon.json] *)
let test_water_pkm = generate_test_pkm water_pokemon 0

(* The following create level_up test variables. *)

(** [generate_able_levelup pkm] is a test function used to generate a pokemon
    that has the experience needed to level up from a pokemon [pkm]. *)
let generate_able_levelup pkm = 
  let curr_stats = pkm.stats in 
  let new_stats = {curr_stats with curr_exp = curr_stats.level_up_exp} in 
  {pkm with stats = new_stats}

let able_level_starter = generate_able_levelup test_starter_pkm
let able_level_grass = generate_able_levelup test_grass_pkm
let able_level_water = generate_able_levelup test_water_pkm

let leveled_up_starter_stats = {
  level = 6;
  base_hp = 55;
  hp = 55;
  attack = 64;
  defense = 59;
  curr_exp = 0;
  level_up_exp = 52;
}
let leveled_up_starter = 
  {test_starter_pkm with stats = leveled_up_starter_stats}

let leveled_up_grass_stats = {
  level = 6;
  base_hp = 49;
  hp = 49;
  attack = 67;
  defense = 53;
  curr_exp = 0;
  level_up_exp = 52;
}
let leveled_up_grass = 
  {test_grass_pkm with stats = leveled_up_grass_stats}

let leveled_up_water_stats = {
  level = 3;
  base_hp = 54;
  hp = 54;
  attack = 63;
  defense = 75;
  curr_exp = 0;
  level_up_exp = 52;
}
let leveled_up_water = {test_water_pkm with stats = leveled_up_water_stats}

(* The following create increase_exp test variables. *) 

let increased_exp_starter_stats = {
  level = 5;
  base_hp = 45;
  hp = 45;
  attack = 49;
  defense = 49;
  curr_exp = 6;
  level_up_exp = 50;
}
let increased_exp_starter = 
  {test_starter_pkm with stats = increased_exp_starter_stats}

let increased_exp_grass_stats = {
  level = 5;
  base_hp = 39;
  hp = 39;
  attack = 52;
  defense = 43;
  curr_exp = 6;
  level_up_exp = 50;
}
let increased_exp_grass = 
  {test_grass_pkm with stats = increased_exp_grass_stats}

let increased_exp_water_stats = {
  level = 2;
  base_hp = 44;
  hp = 44;
  attack = 48;
  defense = 65;
  curr_exp = 2;
  level_up_exp = 50;
}
let increased_exp_water = 
  {test_water_pkm with stats = increased_exp_water_stats}

(* The following create battle_damage test variables *)

(* Stats after bulbasaur uses vine whip on charmander. *)
let grass_pokemon_damage_stats = {
  level = 5;
  base_hp = 39;
  hp = 35;
  attack = 52;
  defense = 43;
  curr_exp = 0;
  level_up_exp = 50;
}
let damaged_grass_poke =
  {test_grass_pkm with stats = grass_pokemon_damage_stats}

let starter_pokemon_damage_stats = {
  level = 5;
  base_hp = 45;
  hp = 37;
  attack = 49;
  defense = 49;
  curr_exp = 0;
  level_up_exp = 50;
}
let damaged_starter_poke =
  {test_starter_pkm with stats = starter_pokemon_damage_stats}

let water_pokemon_damage_stats = {
  level = 2;
  base_hp = 44;
  hp = 43;
  attack = 48;
  defense = 65;
  curr_exp = 0;
  level_up_exp = 50;
}
let damaged_water_poke =
  {test_water_pkm with stats = water_pokemon_damage_stats}

let low_hp_charmander_stats = {
  level = 5;
  base_hp = 39;
  hp = 3;
  attack = 52;
  defense = 43;
  curr_exp = 0;
  level_up_exp = 50;
}

let low_hp_charmander = 
  {test_grass_pkm with stats = low_hp_charmander_stats}

let damaged_low_charmander_stats = {
  level = 5;
  base_hp = 39;
  hp = 0;
  attack = 52;
  defense = 43;
  curr_exp = 0;
  level_up_exp = 50;
}

let damaged_low_hp_charmander = 
  {test_grass_pkm with stats = damaged_low_charmander_stats}