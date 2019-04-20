module C = Cairo
module F = Float
module L = List
module R = Random

let init_surface (w : int) (h : int) : (C.Surface.t * C.context) =
    let surface = C.Image.create C.Image.ARGB32 w h in
    let cr = C.create surface in
    (surface, cr)

let antialias (cr : C.context) : unit = C.set_antialias cr C.ANTIALIAS_SUBPIXEL

let margins (cr : C.context) (w : float) (h : float) (pad : float) : unit =
    let slide x = x *. pad /. 2.0 in
    let shrink x = x *. (1.0 -. pad) in
    C.translate cr (slide w) (slide h)
    ; C.scale cr (shrink w) (shrink h)

let brush (cr : C.context) (lw : float) (r : float) (g : float) (b : float)
        : unit =
    C.set_line_width cr lw
    ; C.set_source_rgb cr r g b

let rect (cr : C.context) (x : float) (y : float) (w : float) (h : float)
        (r : float) (g : float) (b : float) : unit =
    C.rectangle cr x y w h
    ; C.set_source_rgb cr r g b
    ; C.fill cr

let lines (cr : C.context) (points : float list list) (lw : float) (r : float)
        (g : float) (b : float) : unit =
    let line = function
        | [x; y] -> C.line_to cr x y
        | _ -> () in
    brush cr lw r g b
    ; L.iter line points
    ; C.stroke cr

let dots (cr : C.context) (points : float list list) (lw : float)
        (radius : float) (r : float) (g : float) (b : float) : unit =
    let dot = function
        | [x; y] ->
            C.arc cr x y radius 0.0 (2.0 *. F.pi)
            ; C.stroke cr
        | _ -> () in
    brush cr lw r g b
    ; L.iter dot points

let export (surface : C.Surface.t) (filename : string) : unit =
    C.PNG.write surface filename
    ; C.Surface.finish surface
