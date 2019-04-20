module D = Drawing
module L = List
module S = Spline
module Y = Sys

let main () : unit =
    let k = 1 in
    let y_bound = 500 in
    let x_bound = y_bound * k in
    let x_bound' = float_of_int x_bound in
    let y_bound' = float_of_int y_bound in
    let r = 0.0 in
    let g = 0.0 in
    let b = 0.0 in
    let lw = 0.0025 in
    let radius = 0.035 in
    let pad = 0.35 in
    let surface, cr = D.init_surface x_bound y_bound in
    let points =
        [ [0.0; 0.0]
        ; [0.5; 0.5]
        ; [0.0; 1.0]
        ; [1.0; 0.5]
        ; [0.5; 0.45]
        ; [0.75; 1.0]
        ] in
    let spline = L.map (S.interpolate points) (S.resolution 100) in
    D.antialias cr
    ; D.rect cr 0.0 0.0 x_bound' y_bound' 1.0 1.0 1.0
    ; D.margins cr x_bound' y_bound' pad
    ; D.dots cr points lw radius r g b
    ; D.lines cr spline lw r g b
    ; D.export surface Y.argv.(1)

let () = main ()
