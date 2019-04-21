module D = Drawing
module L = List
module R = Random
module S = Spline
module Y = Sys

let main () : unit =
    let j = 1 in
    let i = 1 in
    let points =
        Y.argv.(1) |> int_of_string |> R.init
        ; L.init (R.int 15) (fun _ -> L.init 2 (fun _ -> R.float 1.0)) in
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
    let linewidth = 0.002 in
    let radius = 0.035 in
    let (surface, context, dimensions) = D.initialize 1000 i j in
    D.antialias context
    ; D.background context dimensions white
    ; D.scale context dimensions
    ; D.dots context points (linewidth /. 4.0) radius black
    ; D.lines context (S.spline points 100) linewidth black
    ; D.export surface Y.argv.(2)

let () = main ()
