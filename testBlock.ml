(**
   Tests for all functions in block.ml.
*)

open OUnit2
open Block

let map_dim_test 
    (name : string) 
    (json : Yojson.Basic.t) 
    (expected_output : map_dimensions) : test = 
  name >:: (fun _ -> 
      assert_equal expected_output (map_dim json))

let string_to_block_test
    (name : string) 
    (s : block_type) 
    (expected_output : block) : test = 
  name >:: (fun _ -> 
      assert_equal expected_output (string_to_block s))

let json_to_list_test
    (name : string) 
    (json : Yojson.Basic.t) 
    (expected_output : string list) : test = 
  name >:: (fun _ -> 
      assert_equal expected_output (json_to_list json))

let list_to_blocks_test
    (name : string) 
    (lst : block_type list) 
    (expected_output : block list) : test = 
  name >:: (fun _ -> 
      assert_equal expected_output (list_to_blocks lst))

let json_to_map_test
    (name : string) 
    (j : string) 
    (expected_output : block array array) : test = 
  name >:: (fun _ -> 
      assert_equal expected_output (json_to_map j))

let rev_matrix_test
    (name : string) 
    (a)
    (expected_output) : test = 
  name >:: (fun _ -> 
      assert_equal expected_output (rev_matrix a))

let get_block_type_test
    (name : string) 
    (t : block) 
    (expected_output : string) : test = 
  name >:: (fun _ -> 
      assert_equal expected_output (get_block_type t))

let map1 = Yojson.Basic.from_file "map_jsons/map1.json"

let maptest = Yojson.Basic.from_file "map_jsons/maptest.json"

let test_matrix = [|[|Grass; Water|]; [|Gym; House|]; [|Road; TallGrass|]; 
                    [|TallGrass; Grass|]|]

let rev_test_matrix = [|[|TallGrass; Grass|]; [|Gym; House|]; 
                        [|Road; TallGrass|]; [|Grass; Water|]|]

let block_tests = [
  map_dim_test "map1 dim test" map1 
    {width = 20; 
     height = 12;};

  string_to_block_test "tall grass to block" "tall grass" TallGrass;

  string_to_block_test "gym to block" "gym" Gym;

  "invalid string_to_block" >:: 
  (fun _ -> assert_raises(InvalidBlock "dirt")
      (fun () -> string_to_block "dirt"));

  json_to_list_test "maptest.json to list" maptest 
    ["grass"; "water"; "gym"; "house"; "road";
     "tall grass"; "tall grass"; "grass"];

  list_to_blocks_test "maptest list to blocks" 
    ["grass"; "water"; "gym"; "house"; "road"; "tall grass"; 
     "tall grass"; "grass"] [Grass; Water; Gym; House; Road; TallGrass; 
                             TallGrass; Grass];

  json_to_map_test "maptest to map" "map_jsons/maptest.json"
    [|[|Grass; Water|]; [|Gym; House|]; [|Road; TallGrass|]; 
      [|TallGrass; Grass|]|];

  rev_matrix_test "reverse matrix test" test_matrix rev_test_matrix;

  get_block_type_test "get tall grass block" TallGrass "tall grass";

  get_block_type_test "get water block" Water "water";
]