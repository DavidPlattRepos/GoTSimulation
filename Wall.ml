open Core.Std
	
open Helpers
	
open WorldObject
	
open WorldObjectI
	
(* ### Part 6 Custom Events ### *)
	
let town_limit = 200
	
	
(** The Wall will spawn a white walker when there are enough towns	
    in the world. *)
	
class wall p kings_landing : world_object_i =
	
object (self)
	
  inherit world_object p
	
	
  (******************************)
	
  (***** Instance Variables *****)
	
  (******************************)
	
	
  (***********************)
	
  (***** Initializer *****)
	
  (***********************)
		
  initializer
	
    self#register_handler World.action_event self#do_action
	
  (**************************)
	
  (***** Event Handlers *****)
	
  (**************************)
	
	
   method private do_action () = 
     if town_limit > (World.fold 
         (fun l r -> match l#smells_like_gold with
	 |Some _-> r+1
         |None -> r) 0) &&
        World.fold (fun a b->a#get_name<> "white_walker" && b) true then
       ignore( Printf.printf "white walkers! ";flush_all();
        new WhiteWalker.white_walker self#get_pos kings_landing);
	
	
  (********************************)
	
  (***** WorldObjectI Methods *****)
	
  (********************************)
	
	
  method! get_name = "wall"
	
	
  method! draw = self#draw_circle (Graphics.rgb 70 100 130) Graphics.white "W"
	
	
  method! draw_z_axis = 1
	
	
end
