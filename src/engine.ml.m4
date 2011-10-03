(*******************************************************************************
 * Copyright (c) 2010 AT&T.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Trevor Jim and Yitzhak Mandelbaum
 *******************************************************************************)

(*
 m4 magic:
 changecom(`(*',`*)')
*)


(** Turn on/off support for full-blown lookahead. *)
let support_FLA = false


define(`IF_TRUE',`ifelse(`$1',`true',$2)')
define(`IFE_TRUE',`ifelse(`$1',`true',`$2',`$3')')
define(`VAR',`$$1')

define(`EXPAND',`$1')

define(`_DEF_ARG',
       ``EXPAND(ifelse(`$1', `$2', `$3',
           `pushdef(`$1',``$2'') dnl
            $3 dnl
            popdef(`$1')'))'')
define(`DEF1', `define(`$1', _DEF_ARG(`$2',VAR(`1'),`$3'))')

define(`_DEF_2ARG',
       ``EXPAND(ifelse(`$1', `$2', `', `pushdef(`$1',``$2'')')dnl
        ifelse(`$3', `$4', `', `pushdef(`$3',``$4'')')dnl
        $5 dnl
        ifelse(`$3', `$4', `', `popdef(`$3')')dnl
        ifelse(`$1', `$2', `', `popdef(`$1')'))'')
define(`DEF2', `define(`$1', _DEF_2ARG(`$2',VAR(`1'),`$3',VAR(`2'),`$4'))')

define(`_DEF_3ARG',
       ``EXPAND(ifelse(`$1', `$2', `', `pushdef(`$1',``$2'')')dnl
        ifelse(`$3', `$4', `', `pushdef(`$3',``$4'')')dnl
        ifelse(`$5', `$6', `', `pushdef(`$5',``$6'')')dnl
        $7 dnl
        ifelse(`$5', `$6', `', `popdef(`$5')')dnl
        ifelse(`$3', `$4', `', `popdef(`$3')')dnl
        ifelse(`$1', `$2', `', `popdef(`$1')'))'')
define(`DEF3', `define(`$1', _DEF_3ARG(`$2',VAR(`1'),`$3',VAR(`2'),
                                       `$4',VAR(`3'),`$5'))')

define(`_DEF_4ARG',
       ``EXPAND(ifelse(`$1', `$2', `', `pushdef(`$1',``$2'')')dnl
        ifelse(`$3', `$4', `', `pushdef(`$3',``$4'')')dnl
        ifelse(`$5', `$6', `', `pushdef(`$5',``$6'')')dnl
        ifelse(`$7', `$8', `', `pushdef(`$7',``$8'')')dnl
        $9 dnl
        ifelse(`$7', `$8', `', `popdef(`$7')')dnl
        ifelse(`$5', `$6', `', `popdef(`$5')')dnl
        ifelse(`$3', `$4', `', `popdef(`$3')')dnl
        ifelse(`$1', `$2', `', `popdef(`$1')'))'')
define(`DEF4', `define(`$1', _DEF_4ARG(`$2',VAR(`1'),`$3',VAR(`2'),
                                       `$4',VAR(`3'),`$5',VAR(`4'),
                                       `$6'))')

define(`argn', `ifelse(`$1', 1, ``$2'',
       `argn(decr(`$1'), shift(shift($@)))')')

define(`_DEF_5ARG',
       ``EXPAND(ifelse(`$1', `$2', `', `pushdef(`$1',``$2'')')dnl
        ifelse(`$3', `$4', `', `pushdef(`$3',``$4'')')dnl
        ifelse(`$5', `$6', `', `pushdef(`$5',``$6'')')dnl
        ifelse(`$7', `$8', `', `pushdef(`$7',``$8'')')dnl
        ifelse(`$9', `argn(`10',$@)', `', `pushdef(`$9',``argn(`10',$@)'')')dnl
        EXPAND(argn(`11',$@))dnl
        ifelse(`$9', `argn(`10',$@)', `', `popdef(`$9')')dnl
        ifelse(`$7', `$8', `', `popdef(`$7')')dnl
        ifelse(`$5', `$6', `', `popdef(`$5')')dnl
        ifelse(`$3', `$4', `', `popdef(`$3')')dnl
        ifelse(`$1', `$2', `', `popdef(`$1')'))'')
define(`DEF5', `define(`$1', _DEF_5ARG(`$2',VAR(`1'),`$3',VAR(`2'),
                                       `$4',VAR(`3'),`$5',VAR(`4'),
                                       `$6',VAR(`5'),
                                       `$7'))')

DEF1(`IF_FLA', `block', `if support_FLA then begin block end')
DEF2(`IFE_FLA', `ibranch', `ebranch', `(if support_FLA then ibranch else ebranch)')

DEF1(`LOG', `block', `if Logging.activated then begin block end')
DEF2(`LOGp', `feature', `message',
     `if Logging.activated then begin
       Logging.log Logging.Features.feature message end')




(**
   Abstract set interface for earley sets and worklists.

   Note: For insertions, the NC versions are basically pure insertions.
   The others are insertion plus some  sort of other bookkeeping/checking.

... TODO

*)

define(`ESET_IMPL',`hier')

define(`IF_HIER',`ifelse(ESET_IMPL,`hier',`$1')')
define(`IF_FLAT',`ifelse(ESET_IMPL,`flat',`$1')')

(**************************************************************)
(**************************************************************)
(**
   Abstract set implementation for hierarchical earley sets and worklists.
*)


IF_HIER(`
define(`ESET_CONTAINER_ITER', `SOCVAS_ITER(`$1',`$2',`$3') ')
define(`ESET_CONTAINER_MAP',  `SOCVAS_MAP(`$1',`$2',`$3') ')
define(`ESET_CONTAINER_FOLD', `SOCVAS_FOLD(`$1',`$2',`$3',`$4',`$5') ')

(*  conditional fold. includes folowup action for sets with > 1
  elements. *)
define(`ESET_CONTAINER_FOLD_C', `SOCVAS_FOLD_C(`$1',`$2',`$3',`$4') ')

define(`ESET_CONTAINER_ADD', `Socvas.MS.add')

define(`ESET_EXTEND_PES_EXPR',`$1, overflow')
define(`ESET_EXTEND_PES_PATT',`$1, ol')
define(`ESET_PT_ADDL_ARGS', `i')
define(`ESET_WLD', `i ol')

DEF1(`ESET_NOT_EMPTY', `ns', `(ns).WI.count > 0')

DEF1(`ESET_CLEAR', `t', `WI.clear t')

define(`PROCESS_WORKLIST',`PROCESS_WORKLIST_HIER(`$1',`$2',`$3',`$4') ')
define(`PROCESS_EOF_WORKLIST', `PROCESS_EOF_WORKLIST_HIER(`$1',`$2',`$3') ')

define(`ESET_MODULE', `ES_hierarchical')

(* We ignore the third argument (the container) because this implementation just
   tracks the transducer state in the pcc. *)
DEF3(`PCS_ADD_CALL_ITEM_C', `pre_cc', `s', `c', `(Pcs.add_call_state pre_cc s)')

(* We ignore the third argument (the element) because this implementation only
   tracks the transducer state in the pcc. *)
DEF3(`PCS_ADD_CALL_ITEM_E', `pre_cc', `s', `elt', `(Pcs.add_call_state pre_cc s)')

define(`ESET_ITEM_PATT', `$1, $2')
')

(**************************************************************)
(**************************************************************)

(**************************************************************)
(**
   Abstract set implementation for flat earley sets and worklists.

   In this setup, a container = a single cva.
*)

IF_FLAT(`
define(`ESET_MODULE', `ES_flat')

define(`ESET_CONTAINER_ITER', `SINGLE_CVA_ITER(`$1',`$2',`$3') ')
define(`ESET_CONTAINER_MAP',  `SINGLE_CVA_MAP(`$1',`$2',`$3') ')
define(`ESET_CONTAINER_FOLD', `SINGLE_CVA_FOLD(`$1',`$2',`$3',`$4',`$5') ')
define(`ESET_CONTAINER_FOLD_C', `SINGLE_CVA_FOLD_C(`$1',`$2') ')

define(`ESET_CONTAINER_ADD', `errprint(`ESET_CONTAINER_ADD undefined for ES_flat') ')

define(`ESET_EXTEND_PES_EXPR',`$1, overflow')
define(`ESET_EXTEND_PES_PATT',`$1, ol')
define(`ESET_PT_ADDL_ARGS', `')
define(`ESET_WLD', `ol')

DEF1(`ESET_NOT_EMPTY', `ns', `not (ESet.Earley_set.is_empty (!(ns)))')

DEF1(`ESET_CLEAR', `t', `t := ESet.Earley_set.empty')

define(`PROCESS_WORKLIST',`PROCESS_WORKLIST_FLAT(`$1',`$2',`$3',`$4') ')

define(`PROCESS_EOF_WORKLIST', `PROCESS_EOF_WORKLIST_FLAT(`$1',`$2',`$3') ')
DEF3(`PCS_ADD_CALL_ITEM_C', `pre_cc', `s', `c', `(Pcs.add_call_item pre_cc {ESet.state=s; cva=c})')
DEF3(`PCS_ADD_CALL_ITEM_E', `pre_cc', `s', `elt', `(Pcs.add_call_item pre_cc {ESet.state=s; cva=elt})')
define(`ESET_ITEM_PATT', `{ESet.state=$1; cva=$2}')
')

(**************************************************************)
(**************************************************************)

(** Debugging use. For internal use only. *)
module Imp_position = struct
  let current_position = ref 0

  let set_position i =
    if Logging.activated then
      begin
        if i mod 100 = 0 then
          Logging.log Logging.Features.position "CP=%d\n%!" i;
      end;
    current_position := i

  let get_position () = !current_position
end

(** ordered queue, mapping ints to lists of elements. *)
module Ordered_queue : sig
  type 'a t
  val init : unit -> 'a t
  val insert : 'a t -> int -> 'a -> unit
  val next : 'a t -> int
  val pop : 'a t -> (int * 'a list)
end = struct

  type 'a t = { mutable count : int; mutable lists : (int * 'a list) array; }

  let init () = { count = 0; lists = Array.make 11 (-1,[]); }

  let _insert q i elt =
    let lists = q.lists in
    let len = Array.length lists in
    if q.count < len then begin
      for k = q.count downto i + 1 do
        Array.unsafe_set lists k (Array.unsafe_get lists (k - 1));
      done;
      Array.unsafe_set lists i elt
    end else begin
      let arr = (Obj.obj (Obj.new_block 0 (len * 2))) in
      Array.blit lists 0 arr 0 i;
      Array.unsafe_set arr i elt;
      Array.blit lists i arr (i + 1) (len - i);
      q.lists <- arr;
    end;
    q.count <- q.count + 1

  let _remove q i =
    let from = i + 1 in
    Array.blit q.lists from q.lists i (q.count - from);
    q.count <- q.count - 1

  let insert q x v =
    if q.count = 0 then _insert q 0 (x, [v])
    else
      let rec bfind arr (key : int) b e =
        if b < e then begin
          let m = (b + e) / 2 in
          let c = key - (fst arr.(m)) in
          if c = 0 then m
          else if c > 0 then bfind arr key (m + 1) e
          else bfind arr key b (m - 1)
        end else e in
      let i = bfind q.lists x 0 (q.count - 1) in
      let (y, l) = q.lists.(i) in
      if x = y then q.lists.(i) <- (y, v::l)
      else if x < y then _insert q i (x, [v])
      else _insert q (i + 1) (x, [v])

  let next q = if q.count > 0 then (fst q.lists.(0)) else -1
  let pop q =
    if q.count > 0 then begin
      let x = q.lists.(0) in
      _remove q 0;
      x
    end else
      (-1, [])
end

module PJ = PamJIT
module PI = Pam_internal
module WI = Wf_set.Int_map

(*

Part I

How should we treat the semval sets? There are two models:

  1) On creation of the map, initialize each element with a freshly allocated
    unique set. Thereafter, only reset existing sets.
  2) On creation of the map, initialize each element to None, and replace with
    Some on demand.
  2a) On creation of the map, initialize each element with the same, dummy,
   set and replace that set with a real one on demand.
  3) Use functional sets, and update the array position on each insertion.
   On creation of the map, initialize each element with the same `empty` element.

Going from 1) to 2) is trading time for space, because 2) avoids preallocating
lots of sets which will possibly never get used but requires a check for None
upon each access. However, if the set data structure has a (very) small representation for
empty sets, then there might little space saving moving from 1) to 2),
making 1) a win-win for time and space.

2a) is an optimization, where a well-known dummy element is used
(kind of like C's NULL) avoiding the None check on each insertion. Instead, the
check for the dummy can be performed once per initialization of a map element, that
is, whereever 1) would call `reset`, 2a) will check for dummy, allocate a fresh set
if needed and reset otherwise. The disadvantage of 2a) compared with 2) is that it
opens up the risk of accidentally using the dummy element (like dereferencing NULL
 in C, only worse, because nothing like SEGFAULT will occur). 2a) seems like the best
choice for representations which require significant space even when empty. For example,
our sparse sets or OCaml's hashtables.


I will use 2a) for starters.

Part II

In practice, I wonder how many different semvals appear for any given
(callset, state) pair in an Earley set, or for every state an NFA set. If the number
is generally small, then it might be worth investigating this strategy for managing
those sets: employ two element comparison functions, one exact and the other an
approximation. Then, let sets grow to fixed sized using insertions with the approximation
and then compact with the exact comparison. If, after compaction, the set is still larger
than the threshold, raise the threshold (to avoid constantly recompacting). From this
general approach we can derive familiar structures:
  1. sets: threshold = 1 and approx. comparison = exact comparison
  2. multi-sets: threshold = inf. and approx. comparison = false.
  3. single-element: threshold = anything > 0 and approx. comparison = true.

I won't start out this general. Instead, I'll start with a standard set abstraction
while allowing the comp. function to be an approximation.

Part III

An alternative to all this, certainly worth comparing for performance, is using
the built-in hashtables of OCaml.  A delta from this would be to use the sparse
sets as a representation for the Hashtables, although I'm not sure that buys us
much.

*)

(*
Need to pass callset by reference b/c might still change. wish there was
a way around this. not a big deal, though.

We map states to sets of callsets (socs). Here is the API for the socs:

    module Socs = struct
      insert
      union
      iter
      mem
    end

In addtion, we have convenience functions which operate on the Int_map itself:

    insert_one int_map state callset
    insert_many int_map state socs

Callset is a subset of the current set. The question is how best to represent it. Could
have pre- version which just keeps indexes in the current set, and the post process it. or,
we could try to get it right the first time.

  The current callset will be treated specially. We will build it as a
  list and then convert it to an array. When new items are created
  which need to point to the current callset, they will be given a ref
  to the empty array. When processing of the current set is complete,
  the current callset list will be converted to an array and saved in
  the pre-existing ref.

  An obvious question is what happens if there is return to the
  current callset? This issue is a second (novel?) motivation for our
  special treatment of returning to the current callset.

  PERF: An additional point on the representation of callsets. Since we are using direct pointers,
  we need to pair callsets with their numeric representation (id) which we use as the key.
  But, then, the socs is actually serving as a map from keys to set-pointers. Currently,
  comparison is done by pulling out the key field of each element and comparing the keys. We could
  speed this up by storing the keys and the data separately. Given that this is a set, we don't
  need to support a fast find operation, only a fast member operation. So, we can represent the
  callset with two data structures: a set of keyes, and an array of key-value pairs. When we need to
  iterate over the set, we use the array; when we need to check membership, we use the set.

*)
(* PERF: does ocamlopt perform escape analysis on refs to
   decide whether they need to be heap allocated? *)

type 'it callset = { id : int;
                    (** identifier, for hashing/comparison purposes. *)

                    mutable data : 'it array;
                    (** an array of items *) }

let mk_callset id = {id=id; data= [||];}
let hash_callset {id=x} = x
let cmp_callset {id=x1} {id=x2} = x1 - x2

(** Triple of Callset, semantic Value, and Argument. *)
type ('it,'sv) cva = 'it callset * 'sv * 'sv

type insertion_result = Ignore_elt | Reprocess_elt | Process_elt

(*
   The current callset is not formed until *after* we're done processing
   the current Earley set. So, trying to return to it will in
   effect be a no op. So, its probably more efficient *not* to
   check for it explicitly because the cost of always
   checking outways the possible benefit of saving the no-op
   completion in the case of returns to the current
   callset.
*)
(*define(`CURRENT_CALLSET_GUARD', `callset.id <> current_callset.id')*)
define(`CURRENT_CALLSET_GUARD', `true')

(** This module provides dummy values for the [idata] and [inspector]
    fields of the [SEMVAL] signature. Clients wishing to instantiate
    [SEMVAL], can include this module for convenience. *)
module Dummy_inspector = struct
  type idata = unit
  let create_idata () = ()
  let inspect x y = y
  let summarize_inspection x = "n/a"
end

module type TERM_LANG = sig
  type state

  val advance: YkBuf.t -> unit
  val fill : YkBuf.t -> bool

  val save : unit -> state
    (** save terminal-related state. *)

  val restore : state -> unit

  val step_back : YkBuf.t -> unit
    (** step back one "unit" (e.g. a char in scannerless case, a token
        in a standard lexer. *)
end

module Scannerless_term_lang : TERM_LANG = struct
  type state = unit
  let advance = YkBuf.advance
  let fill ykb = YkBuf.fill2 ykb 1
  let save () = ()
  let restore () = ()
  let step_back = YkBuf.step_back
end

module type TOKENIZER = sig
  include TERM_LANG

  type token
  val lex : YkBuf.t -> token option
end

module Make_tokenizer (T : sig
                         type token
                         val f : Lexing.lexbuf -> token
                       end) : TOKENIZER with type token = T.token =
struct

  (* the implementation of lookahead is somewhat broken becuase it
     forces revisiting current position. hence all this work to get
     the functions working for the case of revisiting the current
     position. If the invariant is that fill is never called twice for
     the same position, things become much easier. also, combine with
     fact that lexer advances the input position, so after fill is
     called, get_offset returns incorrect value.  *)

  let dummystate = (-1, true, None)

  type token = T.token
  type state = int * bool * token option
      (** offset, can_scan, current token (might be none)

          We tag the tokens with a position so that the first fill of a
          lookahead will execute correctly.*)

  let lexstate = ref dummystate
    (** single-element map from position to "can scan" and token. the
        position corresponds to the end position of any token that is
        stored, not the start position. *)


  let fill = YkBuf.ocamllex_fill T.f lexstate

  (** force the next call to fill to grab the next token. *)
  let advance ykb = lexstate := dummystate

  let save () = !lexstate
  let restore t = lexstate := t

  let lex ykb = let (_,_,t) = !lexstate in t

  (** TODO: we need to add support for stepping back to the previous token. *)
  let step_back ykb =
    Util.warn Util.Sys_warn "step_back not yet supported for lexers"

end


module type SEMVAL = sig
  type t
  val cmp : t -> t -> int
  type idata
    (** data used for inspecting semantic values. Used for logging
        purposes and can safely be instantiated with dummy types/values.*)

  val create_idata : unit -> idata

  val inspect : t -> idata -> idata
    (** for certain logging, we fold over all live semantic
        values. This function is used in that folding. *)

  val summarize_inspection : idata -> string
    (** return a string summarizing the results of the inspection. The
        string should preferably fit onto a single line. *)
end

module type MYSET = sig
  type elt
  type many_set
  type t = Empty | Singleton of elt | Other of many_set

  val empty : t
  val singleton : elt -> t

  val is_empty : t -> bool
  val cardinal : t -> int

  val mem : elt -> t -> bool
  val add : elt -> t -> t

  val diff : t -> t -> t
  val union : t -> t -> t

  val iter : (elt -> unit) -> t -> unit
  val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a

  module MS : Set.S with type t = many_set and type elt = elt
end


module PJDN = PamJIT.DNELR

module Full_yakker (Terms : TERM_LANG) (Sem_val : SEMVAL) = struct

  module ES_flat = struct

    let compare_cva (c1,v1,a1) (c2,v2,a2) =
      let c = cmp_callset c1 c2 in
      if c <> 0 then c
      else let c = Sem_val.cmp v1 v2 in
      if c <> 0 then c
      else Sem_val.cmp a1 a2

    type item = {state: int; cva: single_cva}
    and single_cva = (item, Sem_val.t) cva

    module Item = struct
      type t = item
      let compare a b =
        let c = a.state - b.state in
        if c <> 0 then c
        else compare_cva a.cva b.cva
    end

    DEF3(`SINGLE_CVA_ITER', `cva', `pattern', `body',`(let pattern = cva in body)')
    DEF3(`SINGLE_CVA_MAP',  `cva', `pattern', `body',`(let pattern = cva in body)')
    DEF5(`SINGLE_CVA_FOLD', `cva', `v_init', `pattern', `p_acc', `body',
       `(let pattern = cva in let p_acc = v_init in body)')
    DEF2(`SINGLE_CVA_FOLD_C', `cva', `case_s', `(match cva with case_s)')

    module Earley_set = Set.Make(Item)

    (* Proto_callset implementation: Earley set datastructure + conversion to array. *)
    module Proto_callset =
    struct

      let empty = Earley_set.empty

      (** First argument is ignored. We include for compatability only. *)
      let create _ = ref empty

      let reset pcc = pcc := empty

      let add_call_item pcc it = pcc := Earley_set.add it !pcc

      let convert_current_callset item_set pcc =
        let cset = !pcc in
        let len = Earley_set.cardinal cset in
        let arr = (Obj.obj (Obj.new_block 0 len) : item array) in
        ignore (Earley_set.fold (fun item i -> Array.unsafe_set arr i item; i+1) cset 0);
        arr

    end

    let create n = ref Earley_set.empty

  (**
      Invocation: [insert_elt worklist es state callset].

      @return [Process_elt], if item was not already in set,
              [Ignore_elt] otherwise.
  *)
  let insert_elt wl es state cva =
    let item = {state=state; cva=cva} in
    let eset = !es in
    if Earley_set.mem item eset then Ignore_elt
    else begin
      LOG(
        let (callset, _, _) = cva in
        Logging.log Logging.Features.reg_ne
          "+o %d:(%d,%d).\n" (Imp_position.get_position ()) state callset.id;
      );
      es := Earley_set.add item eset;
      wl := item :: !wl;
      Process_elt
    end

  (* PERF: inline insert_elt call and drop the ignore. *)
  let insert_elt_ig wl es state x y z = ignore (insert_elt wl es state (x,y,z))

  let insert_elt_nc es state cva =
    LOG(
      let (callset, _, _) = cva in
      Logging.log Logging.Features.reg_ne
        "+> %d:(%d,%d).\n" (Imp_position.get_position ()) state callset.id;
    );
    let item = {state=state; cva=cva} in
    es := Earley_set.add item !es

  let insert_container wl es state cva = ignore (insert_elt wl es state cva)
  let insert_container_nc = insert_elt_nc

  (** Check for a succesful parse. *)
  let check_done term_table start_nt cs =
    LOGp(eof_ne, "Checking for successful parses.\n");
    let do_check start_nt cva = function
      | PJDN.Complete_trans nt
      | PJDN.Complete_p_trans nt ->
          if nt = start_nt then begin
            LOGp(eof_ne, `"Final state found, start symbol.\n"');
            let (callset, _, _) = cva in callset.id = 0
          end else begin
            LOGp(eof_ne, `"Final state found, not start: %d.\n" nt');
            false
          end

      | PJDN.MComplete_trans nts
      | PJDN.MComplete_p_trans nts ->
          if Util.int_array_contains start_nt nts then begin
            LOGp(eof_ne, `"Final state found, start symbol.\n"');
            let (callset, _, _) = cva in callset.id = 0
          end else (LOGp(eof_ne, `"Final states found, no start.\n"'); false)
      | _ -> false in
    Earley_set.exists begin fun {state=s; cva=cva} ->
      LOGp(eof_ne, "Checking state %d.\n" s);
      match term_table.(s) with
        | PJDN.Complete_trans _ | PJDN.Complete_p_trans _
        | PJDN.MComplete_trans _ | PJDN.MComplete_p_trans _ ->
            do_check start_nt cva term_table.(s)

        | PJDN.Many_trans txs ->
            let rec iter_do_check start_nt socvas txs n j =
              if j >= n then false
              else (do_check start_nt socvas txs.(j)
                    || iter_do_check start_nt socvas txs n (j + 1)) in
            iter_do_check start_nt cva txs (Array.length txs) 0

        | PJDN.Box_trans _ | PJDN.When_trans _ | PJDN.When2_trans _ | PJDN.Action_trans _
        | PJDN.Call_p_trans _ | PJDN.Maybe_nullable_trans2 _ | PJDN.Call_trans _| PJDN.Det_multi_trans _
        | PJDN.TokLookahead_trans _ | PJDN.RegLookahead_trans _ | PJDN.ExtLookahead_trans _
        | PJDN.Lookahead_trans _| PJDN.MScan_trans _
        | PJDN.Scan_trans _ | PJDN.No_trans | PJDN.Det_trans _ | PJDN.Lexer_trans _ ->
            false
    end !cs

  (** Collect the succesful parses at eof. *)
  let collect_done_at_eof start_nt successes cs term_table =
    let do_check cva = function
      | PJDN.Complete_trans nt
      | PJDN.Complete_p_trans nt ->
          if nt = start_nt then begin
            LOGp(eof_ne, `"Final state found, start symbol.\n"');
            let (callset, sv, _) = cva in
            if callset.id = 0 then
              successes := sv :: !successes
          end else LOGp(eof_ne, `"Final state found, not start: %d.\n" nt')

      | PJDN.MComplete_trans nts
      | PJDN.MComplete_p_trans nts ->
          if Util.int_array_contains start_nt nts then begin
            LOGp(eof_ne, `"Final state found, start symbol.\n"');
            let (callset, sv, _) = cva in
            if callset.id = 0 then
              successes := sv :: !successes
          end else LOGp(eof_ne, `"Final states found, no start.\n"')
      | _ -> () in
    Earley_set.iter begin fun {state=s; cva=cva} ->
      LOGp(eof_ne, "Checking state %d.\n" s);
      match term_table.(s) with
        | PJDN.Complete_trans _ | PJDN.Complete_p_trans _
        | PJDN.MComplete_trans _ | PJDN.MComplete_p_trans _ ->
            do_check cva term_table.(s)
        | PJDN. Many_trans txs -> Array.iter (do_check cva) txs
        | PJDN.Box_trans _ | PJDN.When_trans _ | PJDN.When2_trans _ | PJDN.Action_trans _
        | PJDN.Call_p_trans _
        | PJDN.Maybe_nullable_trans2 _
        | PJDN.Call_trans _| PJDN.Det_multi_trans _
        | PJDN.TokLookahead_trans _ | PJDN.RegLookahead_trans _ | PJDN.ExtLookahead_trans _
        | PJDN.Lookahead_trans _| PJDN.MScan_trans _
        | PJDN.Scan_trans _ | PJDN.No_trans | PJDN.Det_trans _ | PJDN.Lexer_trans _
            -> ()
    end !cs

  (**
     Early-set inspection code.
  *)

   (** Get the size of an Earley set *)
    let get_size m = Earley_set.cardinal !m

    module Int_set = Hashtbl.Make(struct type t = int
                                         let equal = (==)
                                         let hash x = x end)

    (** invocation: [fold_semvals f earley_set v_0]
        Fold [f] over all semvals in, and reachable-from, the given [earley_set]. *)
    let fold_semvals f earley_set v_0 = failwith "Unimplemented"

    let count_semvals earley_set = fold_semvals (fun _ n -> n + 1) earley_set 0

    (** count the number of semantic values and inspect each one with
        client-specified inspector. *)
    let count_semvals_plus earley_set =
      fold_semvals (fun sv (n, idata) -> n + 1, Sem_val.inspect sv idata)
        earley_set (0, Sem_val.create_idata ())

    let inspect_semvals earley_set =
      fold_semvals Sem_val.inspect earley_set (Sem_val.create_idata ())

  end

  (**************************************************************)
  (**************************************************************)



  (************************************************************************)
  (************************************************************************)

  (** A hiearchical implementation of Earley sets and worklists. *)

  module ES_hierarchical = struct

    module rec Socvas : MYSET with type elt = ((int * Socvas.t), Sem_val.t) cva
      =
    struct
      type elt = ((int * Socvas.t), Sem_val.t) cva
      module CVA = struct
        type t = elt
        let compare (c1,v1,a1) (c2,v2,a2) =
          let c = cmp_callset c1 c2 in
          if c <> 0 then c
          else let c = Sem_val.cmp v1 v2 in
          if c <> 0 then c
          else Sem_val.cmp a1 a2
      end

      module MS = Set.Make(CVA)
      type many_set = MS.t
      type t = Empty | Singleton of elt | Other of many_set

      let empty = Empty
      let singleton x = Singleton x
      let is_empty = function
        | Empty -> true
        | _ -> false

      let cardinal = function
        | Empty -> 0
        | Singleton _ -> 1
        | Other s -> MS.cardinal s

      let mem x = function
        | Empty -> false
        | Singleton y -> CVA.compare x y = 0
        | Other s -> MS.mem x s

      let add x = function
        | Empty -> Singleton x
        | Singleton y -> Other (MS.add x (MS.singleton y))
        | Other s -> Other (MS.add x s)

      let diff s1 s2 =
        match s1, s2 with
          | Empty, _  -> Empty
          | _, Empty  -> s1
          | Singleton x, Singleton y -> if CVA.compare x y = 0 then Empty else s1
          | Singleton x, Other s -> if MS.mem x s then Empty else s1
          | Other s, Singleton y -> Other (MS.remove y s)
          | Other ms1, Other ms2 -> Other (MS.diff ms1 ms2)

      let union s1 s2 =
        match s1, s2 with
          | Empty, _  -> s2
          | _, Empty  -> s1
          | Singleton x, Singleton y ->
              if CVA.compare x y = 0 then s1
              else Other (MS.add x (MS.singleton y))
          | Singleton x, Other s -> Other (MS.add x s)
          | Other s, Singleton y -> Other (MS.add y s)
          | Other ms1, Other ms2 -> Other (MS.union ms1 ms2)

      let iter f = function
        | Empty -> ()
        | Singleton y -> f y
        | Other s -> MS.iter f s

      let fold f s v =
        match s with
          | Empty -> v
          | Singleton y -> f y v
          | Other s -> MS.fold f s v
    end

    (* DEF3(`SOCVAS_ITER', `socvas', `pattern', `body', `Socvas.iter (fun pattern -> body) socvas') *)

    DEF3(`SOCVAS_ITER', `socvas', `pattern', `body',
         `(match socvas with
             | Socvas.Empty -> ()
             | Socvas.Singleton pattern -> (body)
             | Socvas.Other __s__ -> Socvas.MS.iter (fun pattern -> body) __s__)')

    DEF5(`SOCVAS_FOLD', `socvas', `v_init', `pattern', `p_acc', `body',
         `(match socvas with
             | Socvas.Empty -> v_init
             | Socvas.Singleton pattern -> let p_acc = v_init in (body)
             | Socvas.Other __s__ ->
                 Socvas.MS.fold
                   (fun pattern p_acc -> body)
                   __s__ v_init)')

    (** Special version when fold is building a new Socvas.
        Conditional fold. Does nothing if the set is empty,
        executes [action_s] if the set is a singleton. If the
        set has more than one element, then a fold is executed
        to create a new socvas. Then, if that Socvas is nonempty
        [many_action_fun] is applied to the result.
    *)
    DEF4(`SOCVAS_FOLD_C', `socvas', `case_s', `many_fold_fun', `many_action_fun',
         `(match socvas with
             | Socvas.Empty -> ()
             | Socvas.Singleton case_s
             | Socvas.Other __s__ ->
                 let image = Socvas.MS.fold (many_fold_fun)
                   __s__ Socvas.MS.empty in
                 match Socvas.MS.cardinal image with
                   | 0 -> ()
                   | 1 -> many_action_fun (Socvas.Singleton (Socvas.MS.choose image))
                   | _ -> many_action_fun (Socvas.Other image))')

    (* Note: We have to end with a cardinality check because the
       mapping function is not necessarily 1-to-1. So, we might
       end up with a smaller set than the one with which we began.

       That said, the [0] case should be impossible. TODO.
    *)
    DEF3(`SOCVAS_MAP', `socvas', `pattern', `body',
         `(match socvas with
             | Socvas.Empty -> Socvas.Empty
             | Socvas.Singleton pattern -> Socvas.Singleton (body)
             | Socvas.Other __s__ ->
                 let image = Socvas.MS.fold
                   (fun pattern __image__ -> Socvas.MS.add (body) __image__)
                   __s__ Socvas.MS.empty in
                 match Socvas.MS.cardinal image with
                   | 0 -> Socvas.Empty
                   | 1 -> Socvas.Singleton (Socvas.MS.choose image)
                   | _ -> Socvas.Other image)')

    module Proto_callset_list = struct

      let empty = (0, [])

      (** First argument is ignored. We include for compatability only. *)
      let create _ = ref empty

      let reset pcc = pcc := empty

      let add_call_state pcc s =
        let (pcc_n, pre_cc) = !pcc in
        if List.memq s pre_cc then ()
        else begin
          pcc := (pcc_n + 1, s::pre_cc)
        end

      (** Precondition: [length cc = len]. *)
      let convert_current_callset item_set pcc =
        let rec loop arr item_set i = function
          | [] -> ()
          | x1::[] ->
              Array.unsafe_set arr i (x1, WI.get item_set x1);
          | x1::x2::[] ->
              Array.unsafe_set arr i (x1, WI.get item_set x1);
              Array.unsafe_set arr (i + 1) (x2, WI.get item_set x2)
          | x1::x2::x3::[] ->
              Array.unsafe_set arr i (x1, WI.get item_set x1);
              Array.unsafe_set arr (i + 1) (x2, WI.get item_set x2);
              Array.unsafe_set arr (i + 2) (x3, WI.get item_set x3)
          | x1::x2::x3::x4::[] ->
              Array.unsafe_set arr i (x1, WI.get item_set x1);
              Array.unsafe_set arr (i + 1) (x2, WI.get item_set x2);
              Array.unsafe_set arr (i + 2) (x3, WI.get item_set x3);
              Array.unsafe_set arr (i + 3) (x4, WI.get item_set x4)
          | x1::x2::x3::x4::xs ->
              Array.unsafe_set arr i (x1, WI.get item_set x1);
              Array.unsafe_set arr (i + 1) (x2, WI.get item_set x2);
              Array.unsafe_set arr (i + 2) (x3, WI.get item_set x3);
              Array.unsafe_set arr (i + 3) (x4, WI.get item_set x4);
              loop arr item_set (i + 4) xs in
        let (len, cc) = !pcc in
        let arr = (Obj.obj (Obj.new_block 0 len) : (int * Socvas.t) array) in
        loop arr item_set 0 cc;
        arr
    end

    module Proto_callset_wfis_socvas = struct

      module S = Wf_set.Int_set

      let create = S.make

      let reset pcc = S.clear pcc

      let add_call_state pcc s =
        if S.mem pcc s then ()
        else S.insert pcc s

      let convert_current_callset item_set pcc =
        let len = pcc.S.count in
        let arr = (Obj.obj (Obj.new_block 0 len) : (int * Socvas.t) array) in
        for i = 0 to len - 1 do
          let x = Array.unsafe_get pcc.S.dense i in
          Array.unsafe_set arr i (x, WI.get item_set x);
        done;
        arr
    end

    module Proto_callset = Proto_callset_wfis_socvas

    let create n = WI.make n Socvas.empty

    (**
       Check an item from the worklist for special processing. Specifically,
       if a new (s, cva) pair is added, yet the socvas for s has already been
       processed, we need to process the cva specially.

       Notice that this will only ever happen if you return to the same transducer
       state with a different cva, while processing the current Earley set.

       [i] is the index of the last processed element in the worklist.
       [cs] is the set representing the worklist.

    *)
    let worklist_process_special i cs t = cs.WI.sparse.(t) <= i

    (**
        Invocation: [insert_elt i overflow_list es state callset], where
        [i] is the current position in the worklist view of [es].

        Taken together, [i], [ol] and [es] are a worklist data structure.

        @return [Process_elt], if state was not already in set,
                [Reprocess_elt], if state already in set but callset
                  not associated with that state,
                [Ignore_elt] otherwise.
    *)
    let insert_elt i ol es state cva =
      if WI.mem es state then
        let socvas = WI.get es state in
        if Socvas.mem cva socvas then Ignore_elt
        else begin
          LOG(
            let (callset, _, _) = cva in
            Logging.log Logging.Features.reg_ne
              "+o %d:(%d,%d).\n" (Imp_position.get_position ()) state callset.id;
          );
          WI.set es state (Socvas.add cva socvas);
          if worklist_process_special i es state then
            ol := (state, Socvas.singleton cva) :: !ol;
          Reprocess_elt
        end
      else
        begin
          LOG(
            let (callset, _, _) = cva in
            Logging.log Logging.Features.reg_ne
              "+n %d:(%d,%d).\n" (Imp_position.get_position ()) state callset.id;
          );
          WI.insert es state (Socvas.singleton cva);
          Process_elt
        end


    (* PERF: inline insert_elt call and drop the ignore. *)
    let insert_elt_ig i ol es state x y z = ignore (insert_elt i ol es state (x,y,z))

    let insert_elt_nc es state cva =
      if WI.mem es state then
        let socvas = WI.get es state in
        WI.set es state (Socvas.add cva socvas);

        if Logging.activated then begin
          let (callset, _, _) = cva in
          Logging.log Logging.Features.reg_ne
            "+> %d:(%d,%d).\n" (Imp_position.get_position ()) state callset.id;
        end;
      else
        begin
          WI.insert es state (Socvas.singleton cva);

          if Logging.activated then begin
            let (callset, _, _) = cva in
            Logging.log Logging.Features.reg_ne
              "+> %d:(%d,%d).\n" (Imp_position.get_position ()) state callset.id;
          end
        end

    let insert_container i ol es state socvas_new =
      if WI.mem es state then begin
        LOG(
          Logging.log Logging.Features.reg_ne
            "+o %d:(%d,?).\n" (Imp_position.get_position ()) state;
        );

        let socvas = WI.get es state in
        if worklist_process_special i es state then begin
          let s_d = Socvas.diff socvas_new socvas in
          if not (Socvas.is_empty s_d) then begin
            WI.set es state (Socvas.union s_d socvas);
            ol := (state, s_d) :: !ol;
          end
        end else begin
          WI.set es state (Socvas.union socvas_new socvas);
        end
      end
      else begin
        LOG(
          Logging.log Logging.Features.reg_ne
            "+n %d:(%d,?).\n" (Imp_position.get_position ()) state
        );
        WI.insert es state socvas_new
      end

    (** [insert_container] but without checking for newness. *)
    let insert_container_nc es state socvas_new =
      if WI.mem es state then begin
        LOG(
          Logging.log Logging.Features.reg_ne
            "+> %d:(%d,?).\n" (Imp_position.get_position ()) state
        );
        let socvas = WI.get es state in
        WI.set es state (Socvas.union socvas socvas_new)
      end
      else begin
        LOG(
          Logging.log Logging.Features.reg_ne
            "+> %d:(%d,?).\n" (Imp_position.get_position ()) state
        );
        WI.insert es state socvas_new
      end

    (** Check for a succesful parse. *)
    let check_done term_table start_nt cs =
      let d = cs.WI.dense_s in
      let dcs = cs.WI.dense_sv in
      let count = cs.WI.count in
      let check_callset (callset, _, _) b = b || callset.id = 0 in
      LOGp(eof_ne, "Checking for successful parses.\n");
      let do_check start_nt socvas = function
        | PJDN.Complete_trans nt
        | PJDN.Complete_p_trans nt ->
            if nt = start_nt then begin
              LOGp(eof_ne, `"Final state found, start symbol.\n"');
              Socvas.fold check_callset socvas false
            end else begin
              LOGp(eof_ne, `"Final state found, not start: %d.\n" nt');
              false
            end

        | PJDN.MComplete_trans nts
        | PJDN.MComplete_p_trans nts ->
            if Util.int_array_contains start_nt nts then begin
              LOGp(eof_ne, `"Final state found, start symbol.\n"');
              Socvas.fold check_callset socvas false
            end else (LOGp(eof_ne, `"Final states found, no start.\n"'); false)
        | _ -> false in
      let rec iter_do_check start_nt socvas txs n j =
        if j >= n then false
        else (do_check start_nt socvas txs.(j)
              || iter_do_check start_nt socvas txs n (j + 1)) in
      let rec search_for_succ term_table d dcs start_nt n j  =
        if j >= n then false else begin
          let s = d.(j) in
          LOGp(eof_ne, "Checking state %d.\n" s);
          let is_done = match term_table.(s) with
            | PJDN.Complete_trans _ | PJDN.Complete_p_trans _
            | PJDN.MComplete_trans _ | PJDN.MComplete_p_trans _ ->
                do_check start_nt dcs.(j) term_table.(s)
            | PJDN.Many_trans txs -> iter_do_check start_nt dcs.(j) txs (Array.length txs) 0
            | PJDN.Box_trans _ | PJDN.When_trans _ | PJDN.When2_trans _ | PJDN.Action_trans _
            | PJDN.Call_p_trans _
            | PJDN.Maybe_nullable_trans2 _
            | PJDN.Call_trans _| PJDN.Det_multi_trans _
            | PJDN.TokLookahead_trans _ | PJDN.RegLookahead_trans _ | PJDN.ExtLookahead_trans _
            | PJDN.Lookahead_trans _| PJDN.MScan_trans _
            | PJDN.Scan_trans _ | PJDN.No_trans | PJDN.Det_trans _ | PJDN.Lexer_trans _ -> false in
          is_done || search_for_succ term_table d dcs start_nt n (j + 1)
        end in
      search_for_succ term_table d dcs start_nt count 0

    (** Collect the succesful parses at eof. *)
    let collect_done_at_eof start_nt successes cs term_table =
      let d = cs.WI.dense_s in
      let dcs = cs.WI.dense_sv in
      let count = cs.WI.count in
      let do_check socvas = function
        | PJDN.Complete_trans nt
        | PJDN.Complete_p_trans nt ->
            if nt = start_nt then begin
              LOGp(eof_ne, `"Final state found, start symbol.\n"');
              successes :=
                Socvas.fold (fun (callset, sv, _) a ->
                               if callset.id <> 0 then a else sv::a)
                  socvas
                  !successes
            end else LOGp(eof_ne, `"Final state found, not start: %d.\n" nt')

        | PJDN.MComplete_trans nts
        | PJDN.MComplete_p_trans nts ->
            if Util.int_array_contains start_nt nts then begin
              LOGp(eof_ne, `"Final state found, start symbol.\n"');
              successes :=
                Socvas.fold (fun (callset, sv, _) a ->
                               if callset.id <> 0 then a else sv::a)
                  socvas
                  !successes
            end else LOGp(eof_ne, `"Final states found, no start.\n"')
        | _ -> () in
      for j = 0 to count - 1 do
        let s = d.(j) in
        LOGp(eof_ne, "Checking state %d.\n" s);
        match term_table.(s) with
          | PJDN.Complete_trans _ | PJDN.Complete_p_trans _
          | PJDN.MComplete_trans _ | PJDN.MComplete_p_trans _ ->
              do_check dcs.(j) term_table.(s)
          | PJDN. Many_trans txs -> Array.iter (do_check dcs.(j)) txs
          | PJDN.Box_trans _ | PJDN.When_trans _ | PJDN.When2_trans _ | PJDN.Action_trans _
          | PJDN.Call_p_trans _
          | PJDN.Maybe_nullable_trans2 _
          | PJDN.Call_trans _| PJDN.Det_multi_trans _
          | PJDN.TokLookahead_trans _ | PJDN.RegLookahead_trans _ | PJDN.ExtLookahead_trans _
          | PJDN.Lookahead_trans _| PJDN.MScan_trans _
          | PJDN.Scan_trans _ | PJDN.No_trans | PJDN.Det_trans _ | PJDN.Lexer_trans _
              -> ()
      done

    (**
       Early-set inspection code.
    *)

    (** Get the size of an Earley set *)
    let get_size m = WI.fold (fun _ socvas n -> n + (Socvas.cardinal socvas)) m 0

    module Int_set = Hashtbl.Make(struct type t = int
                                         let equal = (==)
                                         let hash x = x end)

    (** invocation: [fold_semvals f earley_set v_0]
        Fold [f] over all semvals in, and reachable-from, the given [earley_set]. *)
    let fold_semvals f earley_set v_0 =
      let visited = Int_set.create 11 in
      let rec fold_callset callset v =
        if Int_set.mem visited callset.id then v
        else begin
          Int_set.add visited callset.id ();
          let acc = ref v in
          for i = 0 to Array.length callset.data - 1 do
            let socvas = snd callset.data.(i) in
            acc := fold_socvas socvas !acc;
          done;
          !acc
        end
      (** count the number of semvals in [socvas] and its children *)
      and fold_socvas socvas v =
        SOCVAS_FOLD(`socvas', `v',
                    `(cs, sv, _)', `m', `let v1 = f sv m in fold_callset cs v1') in
      WI.fold (fun _ socvas v -> fold_socvas socvas v) earley_set v_0

    let count_semvals earley_set = fold_semvals (fun _ n -> n + 1) earley_set 0

    (** count the number of semantic values and inspect each one with
        client-specified inspector. *)
    let count_semvals_plus earley_set =
      fold_semvals (fun sv (n, idata) -> n + 1, Sem_val.inspect sv idata)
        earley_set (0, Sem_val.create_idata ())

    let inspect_semvals earley_set =
      fold_semvals Sem_val.inspect earley_set (Sem_val.create_idata ())
  end

  module Socvas = ES_hierarchical.Socvas
  (**************************************************************)
  (**************************************************************)

  module ESet = ESET_MODULE

  module Pcs = ESet.Proto_callset

  let insert_future q j s cva = Ordered_queue.insert q j (s, cva)


  type lrm_instr = Fail_lrm | Done_lrm | Step_lrm of int | Loop_lrm of int

  let lookahead_regexp_NELR0_tbl term_table la_nt ykb start =
    (* TODO: Add handling of boxes and then change PamJIT.is_regular accordingly. *)

    let try_trans la_nt c = function
          | PJDN.Scan_trans (c1, t) -> if c = c1 then Step_lrm t else Fail_lrm
          | PJDN.MScan_trans col -> let t = col.(c) in if t = 0 then Fail_lrm else Step_lrm t
          | PJDN.Lookahead_trans col -> let t = col.(c) in if t = 0 then Fail_lrm else Loop_lrm t
          | PJDN.Det_multi_trans col ->
              let x = col.(c) in
              if x = 0 then Fail_lrm
              else
                let x_action = x land 0x7F000000 in
                let t = x land 0xFFFFFF in
                if x_action = 0
                then Step_lrm t
                else Loop_lrm t
          | PJDN.Complete_trans nt
          | PJDN.Complete_p_trans nt -> if nt = la_nt then Done_lrm else Fail_lrm
          | PJDN.MComplete_trans nts
          | PJDN.MComplete_p_trans nts -> if Util.array_contains la_nt nts then Done_lrm else Fail_lrm
          | _ -> Fail_lrm in

    (* For Many_trans, we try each transition in turn, searching for
       one the that succeeds. This method constitutes a greedy search
       of the NFA, because we accept the first transition that
       succeeds regardless of whether it leads ultimately to a
       successful match. Designed for unoptimized, yet deterministic,
       automaton, where at most one transition will succeed. *)
    let rec loop_eof term_table la_nt ykb s =
      if s <= 0 then false
      else
        match term_table.(s) with
          | PJDN.Lookahead_trans col -> loop_eof term_table la_nt ykb col.(PJ.iEOF)
          | PJDN.Det_multi_trans col ->
              let x = col.(PJ.iEOF) in
              let x_action = x land 0x7F000000 in
              let t = x land 0xFFFFFF in
              if x_action = 0 then false
              else loop_eof term_table la_nt ykb t
          | PJDN.Complete_trans nt
          | PJDN.Complete_p_trans nt -> nt = la_nt
          | PJDN.MComplete_trans nts
          | PJDN.MComplete_p_trans nts -> Util.array_contains la_nt nts
          | PJDN.Many_trans trans ->
              let n = Array.length trans in
              let rec _l term_table la_nt ykb s trans n i =
                if n <= i then false
                else match try_trans la_nt PJ.iEOF trans.(i) with
                  | Fail_lrm | Step_lrm _ -> _l term_table la_nt ykb s trans n (i+1)
                  | Done_lrm -> true
                  | Loop_lrm t -> loop_eof term_table la_nt ykb t in
              _l term_table la_nt ykb s trans n 0
          | _ -> false in
    let rec step term_table la_nt ykb s =
      if YkBuf.fill2 ykb 1 then
        let c = Char.code (YkBuf.get_current ykb) in
        loop term_table la_nt ykb c s
      else
        loop_eof term_table la_nt ykb s
    and loop term_table la_nt ykb c s =
      if s <= 0 then false
      else
        match term_table.(s) with
          | PJDN.Scan_trans (c1, t) -> if c = c1 then (YkBuf.advance ykb; step term_table la_nt ykb t) else false
          | PJDN.MScan_trans col -> YkBuf.advance ykb; step term_table la_nt ykb col.(c)
          | PJDN.Lookahead_trans col -> loop term_table la_nt ykb c col.(c)
          | PJDN.Det_multi_trans col ->
              let x = col.(c) in
              let x_action = x land 0x7F000000 in
              let t = x land 0xFFFFFF in
              if x_action = 0
              then (YkBuf.advance ykb; step term_table la_nt ykb t)
              else loop term_table la_nt ykb c t
          | PJDN.Complete_trans nt
          | PJDN.Complete_p_trans nt -> nt = la_nt
          | PJDN.MComplete_trans nts
          | PJDN.MComplete_p_trans nts -> Util.array_contains la_nt nts
          | PJDN.Many_trans trans ->
              let n = Array.length trans in
              let rec _l term_table la_nt ykb c s trans n i =
                if n <= i then false
                else match try_trans la_nt c trans.(i) with
                  | Fail_lrm -> _l term_table la_nt ykb c s trans n (i+1)
                  | Done_lrm -> true
                  | Step_lrm t -> (YkBuf.advance ykb; step term_table la_nt ykb t)
                  | Loop_lrm t -> loop term_table la_nt ykb c t in
              _l term_table la_nt ykb c s trans n 0
          | _ -> false in
    step term_table la_nt ykb start

      (* PERF: push [is_new] binding code into logging -- it plays no other role. *)
  DEF2(`CALL_CODE', `target', `grow_callset',`(
     IF_TRUE(grow_callset,`PCS_ADD_CALL_ITEM_C(`pre_cc', `s', `socvas_s');')
     let target_cva = (current_callset, sv0, sv0) in
     let is_new =
       match ESet.insert_elt ESET_WLD cs target target_cva with
         | Ignore_elt -> false
         | Reprocess_elt -> true
         | Process_elt ->
             IF_TRUE(grow_callset,`PCS_ADD_CALL_ITEM_E(`pre_cc', `target', `target_cva');')
               true in

     LOG(
       if is_new then begin
         Logging.log Logging.Features.calls_ne
           "+C %d:%d.\n" (Imp_position.get_position ()) target;

         if Logging.features_are_set Logging.Features.stats then begin
           let n = PamJIT.DNELR.count_reachable_calls term_table target in
           Logging.Distributions.add_value "MCC" n;
         end;
       end
     );
  )')

  DEF3(`CALL_P_CODE', `target', `grow_callset', `call_act',`(
     IF_TRUE(grow_callset,`PCS_ADD_CALL_ITEM_C(`pre_cc', `s', `socvas_s');')
     ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)',
       `let curr_pos = current_callset.id in
        let arg = call_act curr_pos sv in
        IFE_TRUE(grow_callset,
        `let target_cva = (current_callset, arg, arg) in
         (match ESet.insert_elt ESET_WLD cs target target_cva with
            | Ignore_elt | Reprocess_elt -> ()
            | Process_elt -> PCS_ADD_CALL_ITEM_E(`pre_cc', `target', `target_cva'))',
        `ESet.insert_elt_ig ESET_WLD cs target current_callset arg arg')
     ')
  )')

  DEF2(`MCOMPLETE_CODE', `nts', `no_args', `(
         IF_HIER(`LOG(
           if Logging.features_are_set Logging.Features.stats then begin
             let n = Socvas.cardinal socvas_s in
             Logging.Distributions.add_value
               IFE_TRUE(no_args, `"CSS"', `"CPSS"')
               n;
           end;
         );')
         let m_nts = Array.length nts - 1 in
         IFE_TRUE(no_args, `',`let curr_pos = current_callset.id in')
           ESET_CONTAINER_ITER(`socvas_s',
                       `IFE_TRUE(no_args, `(callset, _, _)', `(callset, sv, sv_arg)') ',
                       `let items = callset.data in
                       for l = 0 to Array.length items - 1 do
                         let ESET_ITEM_PATT(`s_l', `socvas_l') = items.(l) in
                         for k = 0 to m_nts do
                           let t = PJ.lookup_trans_nt nonterm_table s_l nts.(k) in
                           if t > 0 then ESet.insert_container ESET_WLD cs t socvas_l;
                           IFE_TRUE(no_args, `',
                                    `match PJDN.lookup_trans_pnt p_nonterm_table s_l nts.(k) with
                                      | [||] -> ()
                                      | entries ->
                                          for idx = 0 to Array.length entries - 1 do
                                            let {PJDN.ctarget = t; carg = arg_act; cbinder = binder} = entries.(idx) in
                                            LOGp(comp_ne, "@%d: %d => %d [%d(_)]? " callset.id s_l t nts.(k));
                                            ESET_CONTAINER_ITER(`socvas_l', `(callset_s_l, sv_s_l, sv_arg_s_l)', `
                                                          if Sem_val.cmp (arg_act callset.id sv_s_l) sv_arg = 0 then begin
                                                            LOGp(comp_ne, "Y");
                                                            ESet.insert_elt_ig ESET_WLD cs t callset_s_l (binder curr_pos sv_s_l sv) sv_arg_s_l
                                                          end else LOGp(comp_ne, "N")');
                                            LOGp(comp_ne, "\n");
                                          done');
                         done
                       done ')
       )')

  DEF4(`REGLA_CODE', `presence', `la_target', `la_nt', `target',`(
     let cp = YkBuf.save ykb in
     if Logging.activated then begin
       let cf = !Logging.current_features in
       Logging.set_features Logging.Features.none;
       let old_pos = Imp_position.get_position () in

       let b = lookahead_regexp_NELR0_tbl term_table la_nt ykb la_target in

       Logging.set_features cf;
       let lookahead_pos = Imp_position.get_position () in
       Imp_position.set_position old_pos;
       let result = b = presence in
       if result then begin
         Logging.log Logging.Features.lookahead
           "Lookahead failed: %d.\n" lookahead_pos
       end else begin
         Logging.log Logging.Features.lookahead
           "Lookahead succeeded: %d.\n" lookahead_pos;
       end;
       YkBuf.restore ykb cp;
       result
     end else begin
       let b = lookahead_regexp_NELR0_tbl term_table la_nt ykb la_target in
       YkBuf.restore ykb cp;
       b = presence
     end
  )')

  DEF4(`EXTLA_CODE', `presence', `la_target', `la_nt', `target',
    `(presence = nplookahead_fn la_nt la_target ykb)')


  DEF4(`PROCESS_WORKLIST_HIER', `pes', `cs', `term_table', `overflow',`
         begin
           let d = cs.WI.dense_s in
           let dcs = cs.WI.dense_sv in

           let i = ref 0 in
           while !i < cs.WI.count do
             let rec loop pes d dcs k overflow cs term_table =
               let s = d.(k) in

               (* Process state s *)
          (* FINAL VERSION (PERF): inline this call by hand but take care with
             socvas_s -> dcs.(!i) in inlined version because both dcs and i are mutable
             so you need to add
             let socvas_s = dcs.(!i) in some cases rather than simply substituting.
          *)
          process_trans pes s dcs.(k) k term_table.(s);

          let k2 = k + 1 in
          if k2 < cs.WI.count then
            loop pes d dcs k2 overflow cs term_table
          else k
        in

        i := loop pes d dcs !i overflow cs term_table;

        (* Handle overflow from the worklist. *)
        while !overflow <> [] do
          let owl = !overflow in
          overflow := [];
          (* Effectively, List.iter inlined to avoid closure allocation: *)
          let rec loop pes k term_table = function
            | [] -> ()
            | (s, socvas)::xs ->
                process_trans pes s socvas k term_table.(s);
                loop pes k term_table xs in
          loop pes !i term_table owl;
        done;

        incr i;
      done;
    end ' )

  DEF3(`PROCESS_EOF_WORKLIST_HIER', `cs', `proc_eof_item', `overflow',
   `begin
      let d = cs.WI.dense_s in
      let dcs = cs.WI.dense_sv in
      let i = ref 0 in
      while !i < cs.WI.count do
        while !i < cs.WI.count do
          let s = d.(!i) in

          LOGp(eof_ne, "Processing state %d.\n" s);

          (* Process state s *)
          let k = !i in
          proc_eof_item k overflow s dcs.(k);

          incr i;
        done;

        decr i;
        (* Handle overflow from the worklist. *)
        while !overflow <> [] do
          let owl = !overflow in
          overflow := [];
          List.iter (fun (s, socvas) -> proc_eof_item !i overflow s socvas) owl;
        done;

        incr i;
      done;
   end ' )

  DEF4(`PROCESS_WORKLIST_FLAT', `pes', `cs', `term_table', `worklist',`
    begin
      (* Breadth-first processing of Earley set. *)

      worklist := ESet.Earley_set.elements !cs;
      while !worklist <> [] do
        let wl = !worklist in
        worklist := [];
        (* Effectively, List.iter inlined to avoid closure allocation: *)
        let rec loop pes term_table = function
          | [] -> ()
          | {ESet.state=s; cva=cva} :: wl ->
              process_trans pes s cva term_table.(s);
              loop pes term_table wl in
        loop pes term_table wl;
      done;
    end ' )

  DEF3(`PROCESS_EOF_WORKLIST_FLAT', `cs', `proc_eof_item', `worklist',
   `begin
     (* Breadth-first processing of Earley set. *)
     worklist := ESet.Earley_set.elements !cs;
     while !worklist <> [] do
       let wl = !worklist in
       worklist := [];
       List.iter (fun {ESet.state=s; cva=cva} -> proc_eof_item overflow s cva) wl;
     done;
   end ' )


  (** Invokes full-blown lookahead in CfgLA case. *)
  let rec mk_lookahead term_table nonterm_table p_nonterm_table sv0
      la_nt la_target ykb =
    let sv = Terms.save () in
    let cp = YkBuf.save ykb in
    if Logging.activated then begin
      let cf = !Logging.current_features in
      Logging.set_features Logging.Features.none;
      let old_pos = Imp_position.get_position () in

      let r = _parse false
        {PJDN.start_symb = la_nt; start_state = la_target;
         term_table = term_table; nonterm_table = nonterm_table;
         p_nonterm_table = p_nonterm_table;}
        sv0 ykb <> [] in

      Logging.set_features cf;
      Logging.log Logging.Features.lookahead
        "Lookahead: %B @ %d.\n" r (Imp_position.get_position ());
      Imp_position.set_position old_pos;
      YkBuf.restore ykb cp;
      Terms.restore sv;
      r
    end else begin
      let r = _parse false
        {PJDN.start_symb = la_nt; start_state = la_target;
         term_table = term_table; nonterm_table = nonterm_table;
         p_nonterm_table = p_nonterm_table;}
        sv0 ykb <> [] in
      YkBuf.restore ykb cp;
      Terms.restore sv;
      r
    end

  and process_trans
      (** Parse-engine state. *)
      ( ESET_EXTEND_PES_PATT(`
        (** Map from transducer state to transition(s).*)
        term_table,
        (** Map from transducer state to nonterminal transitions, for unparameterized nonterminals.*)
        nonterm_table,
        (** Map from transducer state to nonterminal transitions, for parameterized/merged nonterminals.*)
        p_nonterm_table,
        (** The initial/default semantic value. *)
        sv0,
        (** Current and next Earley sets. *)
        cs, ns,
        (** The nascent current callset. *)
        pre_cc,
        (** The actual current callset. Used only for its id and its pointer --
            the actual contents are meaningless until the [pre_cc] is processed
            and used to backpatch this value. *)
        current_callset,
        (** The input buffer *)
        ykb,
        (** Queue of future items, generated by boxes. *)
        futuresq,
        (** The nullability predicate lookahead function. *)
        nplookahead_fn')
          as
          pes)

      (** The transducer state of the current item. *)
      s
      (** The socvas of the current item.  *)
      socvas_s
      (** (potentially) Worklist-related data. *)
      ESET_PT_ADDL_ARGS = function
           | PJDN.No_trans -> ()
           | PJDN.Scan_trans (c,t) ->
               let c1 = Char.code (YkBuf.get_current ykb) in
               if c1 = c then ESet.insert_container_nc ns t socvas_s
           | PJDN.Det_trans f ->
               let curr_pos = current_callset.id in
               (ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)',
                            `let ret_sv, target = f curr_pos sv in
                             ESet.insert_elt_ig ESET_WLD cs target callset ret_sv sv_arg'))

           | PJDN.MScan_trans col ->
               let c = Char.code (YkBuf.get_current ykb) in
               let t = col.(c) in
               if t > 0 then ESet.insert_container_nc ns t socvas_s
           | PJDN.Lookahead_trans col ->
               let c = Char.code (YkBuf.get_current ykb) in
               let t = col.(c) in
               if t > 0 then ESet.insert_container ESET_WLD cs t socvas_s
           | PJDN.Det_multi_trans col ->
               let c = Char.code (YkBuf.get_current ykb) in
               let x = col.(c) in
               let x_action = x land 0x7F000000 in
               let t = x land 0xFFFFFF in
               if t > 0 then begin
                 if x_action = 0
                 then ESet.insert_container_nc ns t socvas_s
                 else ESet.insert_container ESET_WLD cs t socvas_s
               end

           | PJDN.TokLookahead_trans (presence, f, target) ->
               let b = f ykb in
               if b = presence then ESet.insert_container ESET_WLD cs target socvas_s

           | PJDN.RegLookahead_trans (presence, la_target, la_nt, target) ->
               if REGLA_CODE(`presence', `la_target', `la_nt', `target') then
                 ESet.insert_container ESET_WLD cs target socvas_s

           | PJDN.ExtLookahead_trans (presence, la_target, la_nt, target) ->
               if EXTLA_CODE(`presence', `la_target', `la_nt', `target') then
                 ESet.insert_container ESET_WLD cs target socvas_s

           | PJDN.Call_trans t -> CALL_CODE(`t',`true')
           | PJDN.Call_p_trans (call_act, t) -> CALL_P_CODE(`t',`true',`call_act')

           | PJDN.Complete_trans nt ->
               IF_HIER(`LOG(
                 if Logging.features_are_set Logging.Features.stats then begin
                   let n = Socvas.cardinal socvas_s in
                   Logging.Distributions.add_value "CSS" n;
                 end;
               );')
               ESET_CONTAINER_ITER(`socvas_s', `(callset, _, _)', `
                 if CURRENT_CALLSET_GUARD then begin
                   let items = callset.data in
                   for l = 0 to Array.length items - 1 do
                     let ESET_ITEM_PATT(`s_l', `socvas_l') = items.(l) in
                     let t = PJ.lookup_trans_nt nonterm_table s_l nt in
                     if t > 0 then ESet.insert_container ESET_WLD cs t socvas_l
                   done
                 end')

           | PJDN.Complete_p_trans nt ->
               LOG(
                 IF_HIER(`if Logging.features_are_set Logging.Features.stats then begin
                   let n = Socvas.cardinal socvas_s in
                   Logging.Distributions.add_value "CPSS" n;
                 end;')

                 Logging.log Logging.Features.comp_ne "Attempting completion on nonterminal %d.\n" nt;
               );
               let curr_pos = current_callset.id in
               ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)', `
                 let items = callset.data in
                 for l = 0 to Array.length items - 1 do
                   let ESET_ITEM_PATT(`s_l', `socvas_l') = items.(l) in

                   let t = PJ.lookup_trans_nt nonterm_table s_l nt in
                   if t > 0 then begin
                     ESet.insert_container ESET_WLD cs t socvas_l;
                     LOG(
                       Logging.log Logging.Features.comp_ne "%d => %d [%d]\n" s_l t nt
                     );
                   end;

                   match PJDN.lookup_trans_pnt p_nonterm_table s_l nt with
                     | [||] -> ()
                     | entries ->
                         for idx = 0 to Array.length entries - 1 do
                           let {PJDN.ctarget = t; carg = arg_act; cbinder = binder} = entries.(idx) in
                           LOGp(comp_ne, "@%d: %d => %d [%d(_)]? " callset.id s_l t nt);
                           ESET_CONTAINER_ITER(`socvas_l', `(callset_s_l, sv_s_l, sv_arg_s_l)', `
                                         if Sem_val.cmp (arg_act callset.id sv_s_l) sv_arg = 0 then begin
                                           LOGp(comp_ne, "Y");
                                           ESet.insert_elt_ig ESET_WLD cs t callset_s_l (binder curr_pos sv_s_l sv) sv_arg_s_l
                                         end else LOGp(comp_ne, "N")');
                           LOGp(comp_ne, "\n");
                         done
                 done')

           | PJDN.MComplete_trans nts -> MCOMPLETE_CODE(`nts',`true')
           | PJDN.MComplete_p_trans nts -> MCOMPLETE_CODE(`nts',`false')

           | PJDN.Many_trans trans ->
               let n = Array.length trans in
               for j = 0 to n-1 do
                 process_trans pes s socvas_s ESET_PT_ADDL_ARGS trans.(j)
               done

           | PJDN.Maybe_nullable_trans2 _ -> ()
               (* only relevant immediately after a call *)


           (* There are two different approaches to the next three
              instructions. I'm not sure which one is better, if
              either. My intuition is that for large sets, the latter
              version is better, but the former should excel for small
              sets as it avoids the overhead of building a set only to
              dump it *)

(*            | PJDN.Action_trans (act, target) -> *)
(*                let curr_pos = current_callset.id in *)
(*                ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)', `ESet.insert_elt_ig ESET_WLD cs target callset (act curr_pos sv) sv_arg') *)

(*            | PJDN.When_trans (p, next, target) -> *)
(*                let curr_pos = current_callset.id in *)
(*                ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)', *)
(*                                  `if p curr_pos sv then ESet.insert_elt_ig ESET_WLD cs target callset (next curr_pos sv) sv_arg') *)

(*            | PJDN.When2_trans (p, target) -> *)
(*                ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)', *)
(*                                  `(match p nplookahead_fn ykb sv with *)
(*                                      | None -> () *)
(*                                      | Some new_sv -> ESet.insert_elt_ig ESET_WLD cs target callset new_sv sv_arg)') *)

           | PJDN.Action_trans (act, target) ->
               let curr_pos = current_callset.id in
               let image = ESET_CONTAINER_MAP(`socvas_s', `(callset, sv, sv_arg)', `(callset, (act curr_pos sv), sv_arg)') in
               ESet.insert_container ESET_WLD cs target image

           | PJDN.When_trans (p, next, target) ->
               let curr_pos = current_callset.id in
               ESET_CONTAINER_FOLD_C(`socvas_s',
                   `(callset, sv, sv_arg) ->
                     if p curr_pos sv
                     then ESet.insert_elt_ig ESET_WLD cs target callset (next curr_pos sv) sv_arg
                     else ()',
                   `fun (callset, sv, sv_arg) image ->
                     if p curr_pos sv
                     then ESET_CONTAINER_ADD (callset, (next curr_pos sv), sv_arg) image
                     else image',
                   `ESet.insert_container ESET_WLD cs target ')

           | PJDN.When2_trans (p, target) ->
               ESET_CONTAINER_FOLD_C(`socvas_s',
                   `(callset, sv, sv_arg) ->
                     (match p nplookahead_fn ykb sv with
                       | Some new_sv -> ESet.insert_elt_ig ESET_WLD cs target callset new_sv sv_arg
                       | None -> ())',
                   `fun (callset, sv, sv_arg) image -> match p nplookahead_fn ykb sv with
                       | None -> image
                       | Some new_sv -> ESET_CONTAINER_ADD (callset, new_sv, sv_arg) image',
                   `ESet.insert_container ESET_WLD cs target ')

           | PJDN.Box_trans (box, target) ->
               let curr_pos = current_callset.id in
               (ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)',
                           `let cp = YkBuf.save ykb in
                           (match box sv curr_pos ykb with
                                Some (0, ret_sv) -> (* returns to current set *)
                                  ESet.insert_elt_ig ESET_WLD cs target callset ret_sv sv_arg
                              | Some (1, ret_sv) -> (* returns to next set *)
                                  ESet.insert_elt_nc ns target (callset, ret_sv, sv_arg)
                              | Some (n, ret_sv) ->
                                  let j = curr_pos + n in
                                  insert_future futuresq j target (callset, ret_sv, sv_arg)
                              | None -> ()
                           );
                           YkBuf.restore ykb cp'))

           | PJDN.Lexer_trans lexer ->
               (match lexer ykb with
                  | 0 -> ()
                  | target -> (* returns to next set *)
                      ESet.insert_container_nc ns target socvas_s)

  and process_eof_trans start_nt succeeded cs socvas_s term_table nonterm_table p_nonterm_table nplookahead_fn
      s sv0 current_callset ykb ESET_WLD = function
           | PJDN.No_trans -> ()
           | PJDN.Scan_trans _ | PJDN.MScan_trans _ -> ()
           | PJDN.Lookahead_trans col ->
               let t = col.(PJ.iEOF) in
               if t > 0 then ESet.insert_container ESET_WLD cs t socvas_s
           | PJDN.Det_multi_trans col ->
               let x = col.(PJ.iEOF) in
               let x_action = x land 0x7F000000 in
               let t = x land 0xFFFFFF in
               if t > 0 && x_action > 0 then ESet.insert_container ESET_WLD cs t socvas_s
           | PJDN.TokLookahead_trans (presence, f, target) ->
               let b = f ykb in
               if b = presence then ESet.insert_container ESET_WLD cs target socvas_s
           | PJDN.RegLookahead_trans (presence, la_target, la_nt, target) ->
               let b = REGLA_CODE(`presence', `la_target', `la_nt', `target') in
               if b then ESet.insert_container ESET_WLD cs target socvas_s
           | PJDN.ExtLookahead_trans (presence, la_target, la_nt, target) ->
               if EXTLA_CODE(`presence', `la_target', `la_nt', `target') then
                 ESet.insert_container ESET_WLD cs target socvas_s
           | PJDN.Call_trans t -> CALL_CODE(`t',`false')
           | PJDN.Call_p_trans (call_act, t) -> CALL_P_CODE(`t',`false',`call_act')

           | PJDN.Complete_trans nt ->
               let is_nt = nt = start_nt in
               ESET_CONTAINER_ITER(`socvas_s', `(callset,_,_)', `
                 if is_nt && callset.id = 0 then succeeded := true;
                 let items = callset.data in
                 for l = 0 to Array.length items - 1 do
                   let ESET_ITEM_PATT(`s_l', `c_l') = items.(l) in
                   let t = PJ.lookup_trans_nt nonterm_table s_l nt in
                   if t > 0 then ESet.insert_container ESET_WLD cs t c_l
                 done')

           | PJDN.Complete_p_trans nt ->
               let is_nt = nt = start_nt in
               let curr_pos = current_callset.id in
               ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)', `
                 if is_nt && callset.id = 0 then succeeded := true;
                 let items = callset.data in
                 for l = 0 to Array.length items - 1 do
                   let ESET_ITEM_PATT(`s_l', `socvas_l') = items.(l) in

                   let t = PJ.lookup_trans_nt nonterm_table s_l nt in
                   if t > 0 then ESet.insert_container ESET_WLD cs t socvas_l;

                   match PJDN.lookup_trans_pnt p_nonterm_table s_l nt with
                     | [||] -> ()
                     | entries ->
                         for idx = 0 to Array.length entries - 1 do
                           let {PJDN.ctarget = t; carg = arg_act; cbinder = binder} = entries.(idx) in
                           LOGp(comp_ne, "@%d: %d => %d [%d(_)]? " callset.id s_l t nt);
                           ESET_CONTAINER_ITER(`socvas_l', `(callset_s_l, sv_s_l, sv_arg_s_l)', `
                                         if Sem_val.cmp (arg_act callset.id sv_s_l) sv_arg = 0 then begin
                                           LOGp(comp_ne, "Y");
                                           ESet.insert_elt_ig ESET_WLD cs t callset_s_l (binder curr_pos sv_s_l sv) sv_arg_s_l
                                         end else LOGp(comp_ne, "N")');
                           LOGp(comp_ne, "\n");
                         done

                 done')

           | PJDN.MComplete_trans nts ->
               let m_nts = Array.length nts - 1 in
               ESET_CONTAINER_ITER(`socvas_s', `(callset,_,_)', `
                   let is_start = callset.id = 0 in
                   let items = callset.data in
                   let m_items = Array.length items - 1 in
                   for k = 0 to m_nts do
                     let nt = nts.(k) in
                     if is_start && nt = start_nt then
                       succeeded := true (* ... and do not bother performing the completion. *)
                     else
                       for l = 0 to m_items do
                         let ESET_ITEM_PATT(`s_l', `c_l') = items.(l) in
                         let t = PJ.lookup_trans_nt nonterm_table s_l nt in
                         if t > 0 then ESet.insert_container ESET_WLD cs t c_l
                       done
                   done')

           | PJDN.MComplete_p_trans nts ->
               let m_nts = Array.length nts - 1 in
               let curr_pos = current_callset.id in
               ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)', `
                   let is_start = callset.id = 0 in
                   let items = callset.data in
                   let m_items = Array.length items - 1 in
                   for k = 0 to m_nts do
                     let nt = nts.(k) in
                     if is_start && nt = start_nt then
                       succeeded := true (* ... and do not bother performing the completion. *)
                     else
                       for l = 0 to m_items do
                         let ESET_ITEM_PATT(`s_l', `socvas_l') = items.(l) in

                         let t = PJ.lookup_trans_nt nonterm_table s_l nt in
                         if t > 0 then ESet.insert_container ESET_WLD cs t socvas_l;

                         match PJDN.lookup_trans_pnt p_nonterm_table s_l nt with
                           | [||] -> ()
                           | entries ->
                               for idx = 0 to Array.length entries - 1 do
                                 let {PJDN.ctarget = t; carg = arg_act; cbinder = binder} = entries.(idx) in
                                 LOGp(comp_ne, "@%d: %d => %d [%d(_)]? " callset.id s_l t nt);
                                 ESET_CONTAINER_ITER(`socvas_l', `(callset_s_l, sv_s_l, sv_arg_s_l)', `
                                               if Sem_val.cmp (arg_act callset.id sv_s_l) sv_arg = 0 then begin
                                                 LOGp(comp_ne, "Y");
                                                 ESet.insert_elt_ig ESET_WLD cs t callset_s_l (binder curr_pos sv_s_l sv) sv_arg_s_l
                                               end else LOGp(comp_ne, "N")');
                                 LOGp(comp_ne, "\n");
                               done
                       done
                   done')

           | PJDN.Many_trans trans ->
               let n = Array.length trans in
               for j = 0 to n-1 do
                 process_eof_trans start_nt succeeded cs socvas_s term_table nonterm_table p_nonterm_table nplookahead_fn s sv0
                   current_callset ykb ESET_WLD trans.(j)
               done

           | PJDN.Maybe_nullable_trans2 _ -> ()
               (* only relevant immediately after a call *)

           | PJDN.Action_trans (act, target) ->
               let curr_pos = current_callset.id in
               let image = ESET_CONTAINER_MAP(`socvas_s', `(callset, sv, sv_arg)',
                                              `(callset, (act curr_pos sv), sv_arg)') in
               ESet.insert_container ESET_WLD cs target image

           | PJDN.When_trans (p, next, target) ->
               let curr_pos = current_callset.id in
               ESET_CONTAINER_FOLD_C(`socvas_s',
                   `(callset, sv, sv_arg) ->
                     if p curr_pos sv
                     then ESet.insert_elt_ig ESET_WLD cs target callset (next curr_pos sv) sv_arg
                     else ()',
                   `fun (callset, sv, sv_arg) image ->
                     if p curr_pos sv
                     then ESET_CONTAINER_ADD (callset, (next curr_pos sv), sv_arg) image
                     else image',
                   `ESet.insert_container ESET_WLD cs target ')

           | PJDN.When2_trans (p, target) ->
               ESET_CONTAINER_FOLD_C(`socvas_s',
                   `(callset, sv, sv_arg) ->
                     (match p nplookahead_fn ykb sv with
                       | Some new_sv -> ESet.insert_elt_ig ESET_WLD cs target callset new_sv sv_arg
                       | None -> ())',
                   `fun (callset, sv, sv_arg) image -> match p nplookahead_fn ykb sv with
                       | None -> image
                       | Some new_sv -> ESET_CONTAINER_ADD (callset, new_sv, sv_arg) image',
                   `ESet.insert_container ESET_WLD cs target ')

           | PJDN.Det_trans f ->
               let curr_pos = current_callset.id in
               (ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)',
                            `let ret_sv, target = f curr_pos sv in
                            ESet.insert_elt_ig ESET_WLD cs target callset ret_sv sv_arg'))

           (* Only null boxes are okay now that we've reached EOF. *)
           | PJDN.Box_trans (box, target) ->
               let curr_pos = current_callset.id in
               (ESET_CONTAINER_ITER(`socvas_s', `(callset, sv, sv_arg)',
                           `let cp = YkBuf.save ykb in
                           (match box sv curr_pos ykb with
                                Some (0, ret_sv) -> (* returns to current set *)
                                  ESet.insert_elt_ig ESET_WLD cs target callset ret_sv sv_arg
                              | Some _ -> LOG(Logging.log Logging.Features.verbose "BUG: Box returning success > 0 at EOF.\n")
                              | None -> ()
                           );
                           YkBuf.restore ykb cp'))

           | PJDN.Lexer_trans lexer ->
               (match lexer ykb with
                  | 0 -> ()
                  | target -> ESet.insert_container ESET_WLD cs target socvas_s)

  and _parse is_exact_match
      {PJDN.start_symb = start_nt; start_state = start_state;
       term_table = term_table; nonterm_table = nonterm_table;
       p_nonterm_table = p_nonterm_table;}
      sv0 (ykb : YkBuf.t) =

    LOG(
      if Logging.features_are_set Logging.Features.stats then begin
        Logging.Distributions.init ();
        Logging.Distributions.register "CSS"; (* call-set size. *)
        Logging.Distributions.register "CPSS";(* parameterized call-set size. *)
        Logging.Distributions.register "MCC"; (* Missed call collapsing. *)
      end
    );

    let num_states = Array.length term_table in
    let current_set = ref (ESet.create num_states) in
    let next_set = ref (ESet.create num_states) in

    let pre_cc = Pcs.create num_states in (* pre-version of current callset. *)
    let start_callset = mk_callset 0 in
    let current_callset = ref start_callset in

    let futuresq = Ordered_queue.init () in
    let nplookahead_fn = mk_lookahead term_table nonterm_table p_nonterm_table sv0 in

    if Logging.activated then begin
      Imp_position.set_position 0
    end;

    (* We initialize next_set, rather than current_set, because they
       are swapped first-thing in the loop. *)
    let ns = !next_set in
    let cva0 = (start_callset, sv0, sv0) in
    ESet.insert_elt_nc ns start_state cva0;
    PCS_ADD_CALL_ITEM_E(`pre_cc', `start_state', `cva0');

    let can_scan = ref (Terms.fill ykb) in

    let overflow = ref [] in

    let fast_forward current_callset q ns ykb =
      let (k, l) = Ordered_queue.pop q in
      if k <> -1 then begin
        (* PERF: manually lift up this closure *)
        List.iter (fun (s,cva) -> ESet.insert_elt_nc ns s cva) l;
        ignore (YkBuf.skip ykb (k - !current_callset.id));
        current_callset := mk_callset k;
        YkBuf.fill2 ykb 1
      end else false in


    (**************************************************************
     *                      BEGIN MAIN LOOP
     **************************************************************)

    let s_matched = ref false in
    while ( IFE_FLA(`(is_exact_match || not !s_matched)',`true') &&
              if ESET_NOT_EMPTY(`!next_set') then !can_scan
              else fast_forward current_callset futuresq !next_set ykb) do

      (* swap_and_clear. We place this code here,
         rather than at the end of the loop, with the other
         init code, so that if there's a parse error, the
         previous earley set will be preserved.
         We surround with begin-end to limit scope of t.
      *)
      begin
        let t = !current_set in
        ESET_CLEAR(`t');
        current_set := !next_set;
        next_set := t;
      end;

      (* ensure that only one dereference happens for these datums. Not sure
         if the compiler would be smart enough to do common subexpression
         elimination if we didn't do this aliasing by hand, given that the right
         hand sides are mutable. *)
      let ccs = !current_callset in
      let cs = !current_set in
      let ns = !next_set in

      (**
          Parse-engine state.
      *)
      let pes = ESET_EXTEND_PES_EXPR(`term_table, nonterm_table, p_nonterm_table, sv0,
            cs, ns, pre_cc, ccs, ykb, futuresq, nplookahead_fn') in

      (* Process the worklist (which can grow during processing). *)
      PROCESS_WORKLIST(`pes', `cs', `term_table', `overflow');

      (* Report size of the Earley set. *)
      LOGp(stats, "%d %d\n" ccs.id (ESet.get_size cs));

      (* Report memory size of the data accessable from the Earley set (focusing on
         the semantic values). We use LOG rather than LOGp so that we can ensure
         that memsize is executed before objsize. *)
      LOG(
       `if Logging.features_are_set Logging.Features.hist_size then
         let p = ccs.id in
         if p <= 500 ||
           (p <= 1000 && p mod 10 = 0) ||
           (p <= 10000 && p mod 100 = 0) ||
           (p <= 100000 && p mod 1000 = 0) then
             let msize = Util.memsize () in (* will force a major GC. *)
             let es_size = ESet.get_size cs in
             let sv_count, insp_summary =
               if Logging.features_are_set Logging.Features.verbose then
                 let sv_count, idata = ESet.count_semvals_plus cs in
                 sv_count, Sem_val.summarize_inspection idata
               else 0, "n/a" in
             Logging.log Logging.Features.hist_size "%d %d %d %d %s\n%!"
               p es_size sv_count msize insp_summary'
      );

      IF_FLA(
        `if not is_exact_match && ESet.check_done term_table start_nt cs then
          s_matched := true;'
      );

      (* cleanup and setup for next round. *)
      ccs.data <- Pcs.convert_current_callset cs pre_cc;
      let pos = ccs.id + 1 in
      current_callset := mk_callset pos;
      Terms.advance ykb;
      can_scan := Terms.fill ykb;
      Pcs.reset pre_cc;

      (* Check whether there's any blackbox results to load into the next set. *)
      if Ordered_queue.next futuresq = pos then begin
        let l = snd (Ordered_queue.pop futuresq) in
        List.iter (fun (s,cva) -> ESet.insert_elt_nc ns s cva) l
      end;

      LOG(
        Imp_position.set_position pos;
      );
    done;

    (**************************************************************
     *                      END MAIN LOOP
     **************************************************************)

    LOGp(eof_ne, "Main loop ended with can_scan = %B\n" !can_scan);

    (* PERF: apply the same optimizations used above to the following code. *)

    (* We've either hit a shortest match or we're either at EOF or a failure. *)
    if support_FLA && not is_exact_match && !s_matched then
      [sv0] (* stands in for boolean true. *)
    else if ESET_NOT_EMPTY(`!next_set') then begin
      (* Compute closure on final set. Ignore scans b/c we're at EOF. *)

      let succeeded = ref false in
      let cs = !next_set in

      let proc_eof_item ESET_WLD s socvas =
        LOGp(eof_ne, "Processing state %d.\n" s);
        process_eof_trans start_nt succeeded cs socvas
          term_table nonterm_table p_nonterm_table nplookahead_fn
          s sv0 !current_callset ykb ESET_WLD term_table.(s) in

      PROCESS_EOF_WORKLIST(`cs', `proc_eof_item', `overflow');

      (* Check for succesful parses. *)
      LOGp(eof_ne, "Checking for successful parses.\n");
      let successes = ref [] in
      ESet.collect_done_at_eof start_nt successes cs term_table;

      LOG(
      if Logging.features_are_set Logging.Features.stats then begin
        Logging.Distributions.report ();
      end
      );


      LOG(
       `if Logging.features_are_set Logging.Features.hist_size then
          let ccs = !current_callset in
          let msize = Util.memsize () in (* will force a major GC. *)
          let es_size = ESet.get_size cs in
          let idata_s =
            List.fold_left (fun idata sv -> Sem_val.inspect sv idata)
              (Sem_val.create_idata ()) !successes in
          let insp_summary_s = Sem_val.summarize_inspection idata_s in
          let insp_summary =
            if Logging.features_are_set Logging.Features.verbose then
              let _, idata = ESet.count_semvals_plus cs in
              Sem_val.summarize_inspection idata
            else "0" in
          Logging.log Logging.Features.hist_size
            "Success %d %d %d %s %s\n%!"
            ccs.id es_size msize
            insp_summary insp_summary_s'
      );

      !successes
    end
    else begin
      (* There was no succesful scan of the last element (token, byte,
         etc.), so we backtrack by one to ensure proper error
         reporting -- specifically, that the penultimate element is
         reported as at fault, rather than the EOF. *)
      Terms.step_back ykb;
      LOG(
      if Logging.features_are_set Logging.Features.stats then begin
        Logging.Distributions.report ();
      end
      );
      []
    end

  let parse data sv0 ykb = _parse true data sv0 ykb

end
