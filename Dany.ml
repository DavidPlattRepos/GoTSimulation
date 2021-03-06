open Core.Std
open Event51
open WorldObject
open WorldObjectI

(* ### Part 6 Custom Events ### *)
let spawn_dragon_gold = 500

(** Dany will spawn a dragon when King's Lnading has collected a certain
    amount of gold. *)
class dany p (kings_landing : KingsLanding.kings_landing): world_object_i =
object (self)
  inherit world_object p

  (******************************)
  (***** Instance Variables *****)
  (******************************)

  (* ### TODO: Part 6 Custom Events ### *)

  (***********************)
  (***** Initializer *****)
  (***********************)

  (* ### TODO: Part 6 Custom Events ### *)

  (**************************)
  (***** Event Handlers *****)
  (**************************)

  (* ### TODO: Part 6 Custom Events ### *)
  method private do_action () = 
    if (kings_landing#get_gold > spawn_dragon_gold) &&
       (World.fold (fun a b-> a#get_name <> "dragon" && b) true) 
    then
      (ignore(Printf.printf "dragons! ";flush_all());
       ignore(new Dragon.dragon (self#get_pos) kings_landing 
           (self:>world_object_i)))


  (********************************)
  (***** WorldObjectI Methods *****)
  (********************************)

  (* ### TODO: Part 1 Basic ### *)

  method! get_name = "dany"

  method! draw = self#draw_circle (Graphics.rgb 0x80 0x00 0x80) Graphics.black
                 "D"

  method! draw_z_axis = 1


  (* ### TODO: Part 6 Custom Events *)
   method! receive_gold _ = []

end
