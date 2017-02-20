open Core.Std
open WorldObject
open WorldObjectI
open Human

(** Baratheons will travel in a straight line in a random direction until an
    obstacle or edge of the world is reached, at which point a new random
    direction will be chosen. *)
class lannister p city : human_t =
object (self)
  inherit human p city

  (******************************)
  (***** Instance Variables *****)
  (******************************)

  (* ### TODO: Part 5 Smart Humans *)
  val mutable new_direction = None

  (********************************)
  (***** WorldObjectI Methods *****)
  (********************************)

  (* ### TODO: Part 5 Smart Humans *)
  method! get_name = "lannister"

  (***********************)
  (***** Human Methods *****)
  (***********************)

  (* ### TODO: Part 5 Smart Humans *)
  
   method private direction_finalizer = 
    if World.can_move (Direction.move_point self#get_pos new_direction)
    then new_direction else 
                      (new_direction <- self#direction_helper; new_direction)

  method private direction_helper =
    let x = Some(Direction.random World.rand) in
    if World.can_move (Direction.move_point self#get_pos x)
    then x else self#direction_finalizer	

end


