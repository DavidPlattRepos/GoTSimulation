open Core.Std
open Event51
open Helpers
open WorldObject
open WorldObjectI
open Ageable
open CarbonBased

(* ### Part 2 Movement ### *)
let human_inverse_speed = Some 1

(* ### Part 3 Actions ### *)
let max_gold_types = 5

(* ### Part 4 Aging ### *)
let human_lifetime = 1000

(* ### Part 5 Smart Humans ### *)
let max_sensing_range = 5

class type human_t =
object 
  inherit Ageable.ageable_t
  
  method private next_direction_default : Direction.direction option
end 


(** Humans travel the world searching for towns to trade for gold.
    They are able to sense towns within close range, and they will return
    to King's Landing once they have traded with enough towns. *)
class human p (home:world_object_i): human_t =
object(self)
  inherit CarbonBased.carbon_based p human_inverse_speed (World.rand                                                                     human_lifetime)                                                                 human_lifetime 

  (******************************)
  (***** Instance Variables *****)
  (******************************)

  (* ### TODO: Part 3 Actions ### *)

  val mutable gold_list : int list = []
 
  val sensing_range = World.rand max_sensing_range

  val gold_types = World.rand max_gold_types + 1

  val mutable danger = None
  
(* ### TODO: Part 5 Smart Humans ### *)

  (* ### TODO: Part 6 Custom Events ### *)

  (***********************)
  (***** Initializer *****)
  (***********************)

  (* ### TODO: Part 3 Actions ### *)
   initializer
   (self#register_handler World.action_event self#do_action);
   (self#register_handler home#get_danger_event self#danger_reactor);


  (* ### TODO: Part 6 Custom Events ### *)

  (**************************)
  (***** Event Handlers *****)
  (**************************)

  (* ### TODO: Part 6 Custom Events ### *)
   method private danger_reactor d =
     danger <- Some d;
     self#register_handler d#get_die_event self#remove_danger

   method private remove_danger() =
     danger <- None
         
  (**************************)
  (***** Helper Methods *****)
  (**************************)

  (* ### TODO: Part 3 Actions ### *)
  
  method private deposit_gold neighbor =
   gold_list<- neighbor#receive_gold gold_list

   method private extract_gold neighbor = 
    match neighbor#forfeit_gold with
     | None -> ()
     | Some g -> gold_list <- g::gold_list 
  
   method private do_action () =	
    match danger with	
    |Some x ->	
        if self#get_pos = x#get_pos then	
        begin x#receive_damage; self#die end	
    |None  ->	
        (let rec adj lst =	
         match lst with	
         | hd::tl -> self#extract_gold hd; self#deposit_gold hd; adj tl	
         | [] -> ()	
        in adj (World.get self#get_pos))
  
   method private magnet_gold : world_object_i option =
      let objects = List.filter ~f:(fun arg -> match arg#smells_like_gold with 
     |Some x -> List.mem gold_list x
     |None -> false) (World.objects_within_range self#get_pos sensing_range)
    in match objects with	
   | [] -> None	
   | h::_ -> Some h

  (* ### TODO: Part 5 Smart Humans ### *)

  (********************************)
  (***** WorldObjectI Methods *****)
  (********************************)

  (* ### TODO: Part 1 Basic ### *)

  method! get_name = "human"

  method! draw = self#draw_circle (Graphics.rgb 0xC9 0xC0 0xBB) Graphics.black 
  (string_of_int(List.length gold_list))

  method! draw_z_axis = 2


  (* ### TODO: Part 3 Actions ### *)

  (***************************)
  (***** Ageable Methods *****)
  (***************************)

  (* ### TODO: Part 4 Aging ### *)

  (***************************)
  (***** Movable Methods *****)
  (***************************)

  (* ### TODO: Part 2 Movement ### *)


  method! next_direction = 
    match danger with
    | Some x -> World.direction_from_to self#get_pos x#get_pos
    | None -> if List.length gold_list >= gold_types then 
      World.direction_from_to self#get_pos home#get_pos
    else match self#magnet_gold with
    |Some x -> World.direction_from_to self#get_pos x#get_pos
    |None -> self#next_direction_default


  (* ### TODO: Part 5 Smart Humans ### *)

  (* ### TODO: Part 6 Custom Events ### *)

  (***********************)
  (**** Human Methods ****)
  (***********************)

  (* ### TODO: Part 5 Smart Humans ### *)
  method private next_direction_default = None

end
