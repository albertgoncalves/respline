module D = Drawing
module L = List
module S = Spline
module Y = Sys

let main () : unit =
    let j = 5 in
    let i = 4 in
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
        ; [5.0; 4.0]
        ; [0.0; 4.0]
        ; [5.0; 0.0]
        ] in
    let spline =
        (L.length points) * 50 |> S.slice |> L.map (S.interpolate points) in
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
    let linewidth = 0.0045 in
    let radius = 0.1 in
    let (surface, context, dimensions) = D.initialize 150 i j in
    D.antialias context
    ; D.background context dimensions white
    ; D.scale context dimensions
    ; D.dots context points linewidth radius black
    ; D.lines context spline linewidth black
    ; D.export surface Y.argv.(1)

let () = main ()
