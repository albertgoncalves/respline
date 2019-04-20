module C = Cairo
module D = Drawing
module L = List
module S = Spline
module Y = Sys

let main () : unit =
    let resolution = 500 in
    let k = 3 in
    let l = 3 in
    let w = resolution * k in
    let h = resolution * l in
    let w' = float_of_int w in
    let h' = float_of_int h in
    let r = 0.0 in
    let g = 0.0 in
    let b = 0.0 in
    let lw = 0.0035 in
    let radius = 0.05 in
    let surface, cr = D.init_surface w h in
    let points =
        [ [0.0; 0.0]
        ; [0.5; 0.5]
        ; [0.0; 1.0]
        ; [1.0; 0.5]
        ; [0.5; 0.45]
        ; [1.75; 1.0]
        ; [2.0; 2.0]
        ; [1.0; 2.0]
        ; [3.0; 3.0]
        ] in
    let spline = L.map (S.interpolate points) (S.resolution 100) in
    D.antialias cr
    ; D.rect cr 0.0 0.0 w' h' 1.0 1.0 1.0
    ; C.scale cr (w' /. float_of_int k) (h' /. float_of_int l)
    ; D.dots cr points lw radius r g b
    ; D.lines cr spline lw r g b
    ; D.export surface Y.argv.(1)

let () = main ()
