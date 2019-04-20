module D = Drawing
module L = List
module S = Spline
module Y = Sys

let main () : unit =
    let lw = 0.004 in
    let radius = 0.1 in
    let points =
        [ [0.0; 0.0]
        ; [0.5; 0.5]
        ; [0.0; 1.0]
        ; [1.0; 0.5]
        ; [0.5; 0.45]
        ; [1.75; 1.0]
        ; [2.0; 4.0]
        ; [2.0; 2.0]
        ; [1.0; 2.0]
        ; [3.0; 3.0]
        ; [2.0; 0.0]
        ; [4.0; 4.0]
        ; [0.0; 0.0]
        ] in
    let black : D.color =
        { r = 0.0
        ; g = 0.0
        ; b = 0.0
        } in
    let white : D.color =
        { r = 1.0
        ; g = 1.0
        ; b = 1.0
        } in
    let n = L.length points in
    let spline = L.map (S.interpolate points) (S.slice (n * 50)) in
    let (surface, cr, dimensions) = D.initialize 300 4 4 in
    D.antialias cr
    ; D.background cr dimensions white
    ; D.scale cr dimensions
    ; D.dots cr points lw radius black
    ; D.lines cr spline lw black
    ; D.export surface Y.argv.(1)

let () = main ()
