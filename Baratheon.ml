open Core.Std
open WorldObject
open WorldObjectI
open Human

(** Baratheons will travel in a straight line in a random direction until an
    obstacle or edge of the world is reached, at which point a new random
    direction will be chosen. *)
class baratheon p city : human_t =
object (_)
  inherit human p city

  (******************************)
  (***** Instance Variables *****)
  (******************************)

  (* ### TODO: Part 5 Smart Humans *)

  (********************************)
  (***** WorldObjectI Methods *****)
  (********************************)

  (* ### TODO: Part 5 Smart Humans *)
  method! get_name = "baratheon"

  (***********************)
  (***** Human Methods *****)
  (***********************)

  (* ### TODO: Part 5 Smart Humans *)
  
  method! private next_direction_default = Some(Direction.random World.rand)	

end


