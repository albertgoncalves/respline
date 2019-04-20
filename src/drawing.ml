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
    let context = C.create surface in
    (surface, context, dimensions)

let antialias (context : C.context) : unit =
    C.set_antialias context C.ANTIALIAS_SUBPIXEL

let scale (context : C.context) (dimensions : dimensions) : unit =
    C.scale
        context
        (dimensions.w /. dimensions.j)
        (dimensions.h /. dimensions.i)

let brush (context : C.context) (linewidth : float) (color : color) : unit =
    C.set_line_width context linewidth
    ; C.set_source_rgb context color.r color.g color.b

let background (context : C.context) (dimensions : dimensions) (color : color)
        : unit =
    C.rectangle context 0.0 0.0 dimensions.w dimensions.h
    ; C.set_source_rgb context color.r color.g color.b
    ; C.fill context

let lines (context : C.context) (points : float list list) (linewidth : float)
        (color : color) : unit =
    let line = function
        | x::y::_ -> C.line_to context x y
        | _ -> () in
    brush context linewidth color
    ; L.iter line points
    ; C.stroke context

let dots (context : C.context) (points : float list list) (linewidth : float)
        (radius : float) (color : color) : unit =
    let dot = function
        | x::y::_ ->
            C.arc context x y radius 0.0 (2.0 *. F.pi)
            ; C.stroke context
        | _ -> () in
    brush context linewidth color
    ; L.iter dot points

let export (surface : C.Surface.t) (filename : string) : unit =
    C.PNG.write surface filename
    ; C.Surface.finish surface
