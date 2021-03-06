open State
open Player
open Pokemon
open Block

(** The type representing possible character movement while walking *)
type move = Up | Left | Right | Down

(** The type representing possible displays on the text panel *)
type display = Default | Bag | PokeList

(** The type representing actions associated with certain key inputs *)
type action = Move of move | Display of display

(** [walk_key ch] maps the input key to an action *)
let walk_key ch =
  match ch with
  | 'w' -> Move Up
  | 'a' -> Move Left
  | 's' -> Move Down
  | 'd' -> Move Right
  | 'b' -> Display Bag
  | 'p' -> Display PokeList
  | _ -> Display Default

(** [check_bounds (x1, y1) (x2, y2) map] ensures that the character stays 
    within the bounds of the [map] *)
let check_bounds (x1, y1) (x2, y2) (map : block array array) = 
  let ncol = Array.length map.(0) in
  let nrow = Array.length map in
  if (x2 < 0 || x2 > (ncol - 1)) || (y2 < 0 || y2 > (nrow - 1))
  then (x1, y1) 
  else let block = Array.get (map.(y2)) x2 in
    if block = Null || block = BrownGymFloor
    then (x1, y1) 
    else (x2, y2)

(** [move_map p m map] moves the player to the new location on map *)
let move_map p m map =
  let (x, y) = p.location in
  let new_loc = 
    match m with
    | Up -> (x, y + 1)
    | Left -> (x - 1, y)
    | Down -> (x, y - 1)
    | Right -> (x + 1, y)
  in {p with location=(check_bounds (x, y) new_loc map)}

(** [string_of_item] returns item types as a string *)
let string_of_item = function
  | Potion -> "Potion"
  | Pokeball -> "Pokeball"

let parse_bag p = 
  let bag = p.bag in
  let inventory = bag.inventory in
  let rec parse_inventory = function
    | [] -> ""
    | (item, ct) :: t -> (string_of_item item) ^ ": " ^ string_of_int ct ^ " " 
                         ^ parse_inventory t in 
  parse_inventory inventory

let parse_pokelist (p : Player.player) =
  let pokelist = p.poke_list in
  let rec parse_poke = function
    | [] -> ""
    | pokemon :: t -> (pokemon.name) ^ " Lv:" ^ 
                      string_of_int pokemon.stats.level ^ 
                      " " ^ parse_poke t in
  parse_poke pokelist

(** [display st] displays the state [st] panel text *)
let display (st : State.state) = function
  | Bag -> parse_bag st.player
  | PokeList -> parse_pokelist st.player
  | Default -> 
    "Invalid Key :( Use WASD keys to walk around, P - Pokelist, B - Bag" 

(** [gym_entrance_loc map] is the location of the gym entrance on [map]. *)
let gym_entrance_loc map = 
  let ncol = Array.length map.(0) in 
  let nrow = Array.length map in 
  let loc = ref (0, 0) in 
  for row = 0 to (nrow - 1) do 
    for col = 0 to (ncol - 1) do 
      if map.(row).(col) = Block.Exit then 
        loc := (col, row)
    done; 
  done;
  !loc

(** [gym_loc map] is the location of the gym on [map]. *)
let gym_loc map = 
  let ncol = Array.length map.(0) in 
  let nrow = Array.length map in 
  let loc = ref (0, 0) in 
  for row = 0 to (nrow - 1) do 
    for col = 0 to (ncol - 1) do 
      if map.(row).(col) = Block.Gym then 
        loc := (col, row)
    done; 
  done;
  !loc

(** [walking st dir] is the state after some key input while the 
    player is walking on regular road *)
let walking st dir = 
  let mv_st =  {st with player=(move_map st.player dir st.maps.(0))} in 
  let new_status = 
    (update_status mv_st (player_block mv_st.player mv_st.maps.(0))) in 
  if new_status = EnterGym then 
    let loc = gym_entrance_loc st.maps.(1) in 
    let mv_player = {mv_st.player with location = loc} in 
    {mv_st with player = mv_player; status = WalkingGym}
  else 
    {mv_st with status = new_status}

(** [walking_gym st dir] is the state after some key input while the 
    player is walking on gym road *)
let walking_gym st dir = 
  let mv_st =  {st with player=(move_map st.player dir st.maps.(1))} in 
  let new_status = 
    (update_status mv_st (player_block mv_st.player mv_st.maps.(1))) in 
  match new_status with 
  | ExitGym -> let loc = gym_loc st.maps.(0) in 
    let mv_player = {mv_st.player with location = loc} in 
    {mv_st with player = mv_player; status = Walking}
  | AlreadyBattled -> {st with panel_txt = "We have already battled!";
                               status = WalkingGym}
  | CannotBattle -> {st with panel_txt = "You must battle in order!"; 
                             status = WalkingGym}
  | _ -> {mv_st with status = new_status}

let process_walk input (st : State.state) =
  let action = walk_key input in
  match action with
  | Move dir ->  begin 
      match st.status with 
      | Walking -> walking st dir
      | WalkingGym -> walking_gym st dir
      | _ -> failwith "impossible"
    end 
  | Display x -> {st with panel_txt=(display st x)}