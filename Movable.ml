open Core.Std
open Event51
open Helpers
open WorldObject
open WorldObjectI

(** Class type for objects which constantly try to move in a calculated next
    direction. *)
class type movable_t =
object
  inherit world_object_i

  (** The next direction for which this object should move. *)
  method next_direction : Direction.direction option
end

class movable p (inv_speed:int option) : movable_t =
object (self)
  inherit world_object p

  (***********************)
  (***** Initializer *****)
  (***********************)

  initializer
     match inv_speed with
     | None -> ()
     | Some x -> self#register_handler (Event51.buffer x World.move_event) 
         self#do_move
     

  (**************************)
  (***** Event Handlers *****)
  (**************************)

  method private do_move (_:unit list) = self#move self#next_direction; ()

  (***************************)
  (***** Movable Methods *****)
  (***************************)

  (* ### TODO: Part 2 Movement ### *)
  method next_direction = None

end
