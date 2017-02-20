open Core.Std
open Helpers
open WorldObject
open WorldObjectI
open Ageable
open CarbonBased

(* ### Part 3 Actions ### *)
let next_gold_id = ref 0
let get_next_gold_id () =
  let p = !next_gold_id in incr next_gold_id ; p

(* ### Part 3 Actions ### *)
let max_gold = 5
let produce_gold_probability = 50
let expand_probability = 4000
let forfeit_gold_probability = 3

(* ### Part 4 Aging ### *)
let town_lifetime = 2000

(** Towns produce gold.  They will also eventually die if they are not cross
    pollenated. *)
class town p gold_id : ageable_t =
object (self)
  inherit carbon_based p None (World.rand town_lifetime) 
                              town_lifetime

  (******************************)
  (***** Instance Variables *****)
  (******************************)

  (* ### TODO: Part 3 Actions ### *)
   
  val mutable gold_to_offer = World.rand max_gold

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
     Helpers.with_inv_probability (World.rand) produce_gold_probability 
     (fun()->if gold_to_offer < max_gold then gold_to_offer <- gold_to_offer + 1
                 else ());
      
     Helpers.with_inv_probability (World.rand) expand_probability
         (fun()->
            (World.spawn 1 (self#get_pos) 
                (fun g -> ignore (new town g gold_id);()) );
            () );  
 

  (********************************)
  (***** WorldObjectI Methods *****)
  (********************************)

  (* ### TODO: Part 1 Basic ### *)

  method! get_name = "town"

  method! draw = self#draw_circle (Graphics.rgb 0x96 0x4B 0x00) Graphics.black
  (string_of_int gold_to_offer)
  method! draw_z_axis = 1


  (* ### TODO: Part 4 Aging ### *)

  (* ### TODO: Part 3 Actions ### *)
  method! smells_like_gold = 
       if (gold_to_offer > 0) then Some (gold_id)
       else None
   
  method! forfeit_gold =
     if gold_to_offer>0 && (Random.int forfeit_gold_probability) = 0 then 
       (gold_to_offer <- gold_to_offer - 1; Some(gold_id))
     else None; 
         
 
  (* ### TODO: Part 4 Aging ### *)
  method! receive_gold lst =
    if List.exists ~f:(fun x -> gold_id<>x) lst then 
         (self#reset_life; lst)
    else lst
    
end

