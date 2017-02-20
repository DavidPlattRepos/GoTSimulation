open Core.Std
open Helpers
open WorldObject
open WorldObjectI
open Movable

(* ### Part 2 Movement ### *)
let walker_inverse_speed = Some 1

(* ### Part 6 Custom Events ### *)
let max_destroyed_objects = 100

(** A White Walker will roam the world until it has destroyed a satisfactory
    number of towns *)
class white_walker p kings_landing home : movable =
object (self)
  inherit movable p walker_inverse_speed 

  (******************************)
  (***** Instance Variables *****)
  (******************************)

  (* ### TODO: Part 3 Actions ### *)
 
  val mutable objects_destroyed = 0

  (***********************)
  (***** Initializer *****)
  (***********************)

  (* ### TODO: Part 3 Actions ### *)
  initializer
     self#register_handler World.action_event self#do_action

  (**************************)
  (***** Event Handlers *****)
  (**************************)

  (* ### TODO: Part 3 Actions ### *)
method private do_action () = 
      ignore(List.map ~f:(fun x ->
      if x#smells_like_gold <> None && self#still_dangerous then
      x#die; objects_destroyed <- objects_destroyed + 1) 
        (World.objects_within_range self#get_pos 0));
  
(* ### TODO: Part 6 Custom Events ### *)

  (********************************)
  (***** WorldObjectI Methods *****)
  (********************************)

  (* ### TODO: Part 1 Basic ### *)

  method! get_name = "white_walker"

  method! draw = self#draw_circle (Graphics.rgb 0x89 0xCF 0xF0) Graphics.black
  (string_of_int(objects_destroyed))

  method! draw_z_axis = 4


  (* ### TODO: Part 3 Actions ### *)

  (***************************)
  (***** Movable Methods *****)
  (***************************)

  (* ### TODO: Part 2 Movement ### *)
method! next_direction = 
  if not (self#still_dangerous) 
  then (World.direction_from_to self#get_pos home#get_pos)
  else (if ((Random.int World.size) <= 2) 
        then World.direction_from_to self#get_pos kings_landing#get_pos
        else Some(Direction.random Random.int))

  (* ### TODO: Part 6 Custom Events ### *)
  method private still_dangerous = objects_destroyed < max_destroyed_objects

end
