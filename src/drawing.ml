module C = Cairo
module F = Float
module L = List
module R = Random

type color =
    { r : float
    ; g : float
    ; b : float
    }

type dimensions =
    { h : float
    ; w : float
    ; i : float
    ; j : float
    }

let initialize (resolution : int) (i : int) (j : int)
        : (C.Surface.t * C.context * dimensions) =
    let h = resolution * i in
    let w = resolution * j in
    let dimensions =
        { h = float_of_int h
        ; w = float_of_int w
        ; i = float_of_int i
        ; j = float_of_int j
        } in
    let surface = C.Image.create C.Image.ARGB32 w h in
    let cr = C.create surface in
    (surface, cr, dimensions)

let antialias (cr : C.context) : unit = C.set_antialias cr C.ANTIALIAS_SUBPIXEL

let scale (cr : C.context) (dimensions : dimensions) : unit =
    C.scale cr (dimensions.w /. dimensions.j) (dimensions.h /. dimensions.i)

let brush (cr : C.context) (lw : float) (color : color) : unit =
    C.set_line_width cr lw
    ; C.set_source_rgb cr color.r color.g color.b

let background (cr : C.context) (dimensions : dimensions) (color : color)
        : unit =
    C.rectangle cr 0.0 0.0 dimensions.w dimensions.h
    ; C.set_source_rgb cr color.r color.g color.b
    ; C.fill cr

let lines (cr : C.context) (points : float list list) (lw : float)
        (color : color) : unit =
    let line = function
        | [x; y] -> C.line_to cr x y
        | _ -> () in
    brush cr lw color
    ; L.iter line points
    ; C.stroke cr

let dots (cr : C.context) (points : float list list) (lw : float)
        (radius : float) (color : color) : unit =
    let dot = function
        | [x; y] ->
            C.arc cr x y radius 0.0 (2.0 *. F.pi)
            ; C.stroke cr
        | _ -> () in
    brush cr lw color
    ; L.iter dot points

let export (surface : C.Surface.t) (filename : string) : unit =
    C.PNG.write surface filename
    ; C.Surface.finish surface
