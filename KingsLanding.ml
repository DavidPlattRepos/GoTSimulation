open Core.Std
open Event51
open Helpers
open WorldObject
open WorldObjectI

(* ### Part 3 Actions ### *)
let starting_gold = 500
let cost_of_human = 10
let spawn_probability = 20
let gold_probability = 50
let max_gold_deposit = 3

(** King's Landing will spawn humans and serve as a deposit point for the gold
    that humans gather. It is possible to steal gold from King's Landing;
    however the city will signal that it is in danger and its loyal humans
    will become angry. *)

class kings_landing p :
object
  inherit world_object_i
  method forfeit_treasury : int -> world_object_i -> int
  method get_gold_event: int Event51.event
  method get_gold : int
end =
object (self)
  inherit world_object p 

  (******************************)
  (***** Instance Variables *****)
  (******************************)

  (* ### TODO: Part 3 Actions ### *)
  
  val mutable gold_amount = starting_gold

  (* ### TODO: Part 6 Custom Events ### *)
  val gold_event : int Event51.event = Event51.new_event ()
  
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
    Helpers.with_inv_probability World.rand gold_probability 
      (fun () -> gold_amount <- gold_amount + 1);
      
    Helpers.with_inv_probability World.rand spawn_probability
      (fun () ->  if gold_amount > cost_of_human then
      (self#generate_human (); gold_amount <- gold_amount - cost_of_human)
      else ())

  (* ### TODO: Part 4 Aging ### *)

  (**************************)
  (***** Helper Methods *****)
  (**************************)

  (* ### TODO: Part 4 Aging ### *)
 
 method private generate_human () =	
    let first = (self:>WorldObjectI.world_object_i) in	
    let pos = self#get_pos in	
    let human = Helpers.with_inv_probability_or World.rand 2	
    (fun () -> (let human = new Baratheon.baratheon pos first in	
        human:>WorldObjectI.world_object_i)) 
    (fun () -> (let human = new Lannister.lannister pos first in
        human:>WorldObjectI.world_object_i)) in	
    World.add pos human
  (****************************)
  (*** WorldObjectI Methods ***)
  (****************************)

  (* ### TODO: Part 1 Basic ### *)

  method! get_name = "kings_landing"

  method! draw = self#draw_circle (Graphics.rgb 0xFF 0xD7 0x00) Graphics.black
  (string_of_int gold_amount)
  method! draw_z_axis = 1


  (* ### TODO: Part 3 Actions ### *)
  method! receive_gold lst = 
    let min a b =
        if a > b then b else a in 
        gold_amount <- gold_amount + (min (List.length lst) max_gold_deposit);
    Event51.fire_event gold_event gold_amount;
    []

  method forfeit_treasury n obj = 
    if n < gold_amount then
      (gold_amount <- gold_amount - n; self#danger obj ; n)
    else
      (let y = gold_amount in
        gold_amount <- 0 ; self#danger obj ; y)

  (* ### TODO: Part 6 Custom Events ### *)

  (**********************************)
  (***** King's Landing Methods *****)
  (**********************************)

  (* ### TODO: Part 3 Actions ### *)

  (* ### TODO: Part 6 Custom Events ### *)
  
  method get_gold = gold_amount
 
  method get_gold_event = gold_event

end

