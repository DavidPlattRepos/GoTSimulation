open Core.Std
open Helpers
open WorldObject
open WorldObjectI
open Movable

(* ### Part 3 Actions ### *)
let gold_theft_amount = 1000

(* ### Part 4 Aging ### *)
let dragon_starting_life = 20

(* ### Part 2 Movement ### *)
let dragon_inverse_speed = Some 10

class dragon p kings_landing (home:world_object_i): movable_t =
object (self)
  inherit movable p dragon_inverse_speed

  (******************************)
  (***** Instance Variables *****)
  (******************************)

  (* ### TODO: Part 3 Actions ### *)
  val mutable stolen_gold = 0

  (* ### TODO: Part 6 Events ### *)
  val mutable life = dragon_starting_life

  (***********************)
  (***** Initializer *****)
  (***********************)

  (* ### TODO: Part 3 Actions ### *)
   initializer
     (self#register_handler World.action_event self#do_action);

  (**************************)
  (***** Event Handlers *****)
  (**************************)

  (* ### TODO: Part 3 Actions ### *)
  method private do_action () = 
    if self#get_pos = kings_landing#get_pos then 
     (stolen_gold <- stolen_gold + kings_landing#forfeit_treasury
       gold_theft_amount (self :> world_object_i))
    else if self#get_pos = home#get_pos then
      (stolen_gold <- 0; 
      if kings_landing#get_gold < gold_theft_amount/2 then (self#die) else ())

  (* ### TODO: Part 6 Custom Events ### *)
  method! receive_damage = 
    life <- life - 1; if life = 0 then self#die else ()  

  (********************************)
  (***** WorldObjectI Methods *****)
  (********************************)

  (* ### TODO: Part 1 Basic ### *)

  method! get_name = "dragon"

  method! draw = self#draw_circle Graphics.red Graphics.black 
  (string_of_int(stolen_gold))

  method! draw_z_axis = 3


  (* ### TODO: Part 3 Actions ### *)

  (* ### TODO: Part 6 Custom Events ### *)

  (***************************)
  (***** Movable Methods *****)
  (***************************)

  (* ### TODO: Part 2 Movement ### *)

  method! next_direction = 
  if stolen_gold = 0 
  then (World.direction_from_to self#get_pos kings_landing#get_pos)
  else (World.direction_from_to self#get_pos home#get_pos)


  (* ### TODO: Part 6 Custom Events ### *)

end
