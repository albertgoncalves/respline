module D = Drawing
module L = List
module R = Random
module S = Spline
module Y = Sys

let coordinate (min : float) (max : float) : float =
    (R.float (max -. min)) +. min

let points (n : int) (xmin : float) (xmax : float) (ymin : float)
        (ymax : float) : float list list
    = L.init n (fun _ -> [coordinate xmin xmax; coordinate ymin ymax])

let sentences (n : int) (i : int) (j : int) : float list list list =
    L.init i (fun i' ->
        L.concat (L.init j (fun j' ->
            let i' = float_of_int i' in
            let j' = float_of_int j' in
            points (R.int n) j' (j' +. 1.0) i' (i' +. 1.0))))

let main () : unit =
    let j = Y.argv.(2) |> int_of_string in
    let i = Y.argv.(3) |> int_of_string in
    let resolution = 500 / (min i j) in
    let points' =
        Y.argv.(1) |> int_of_string |> R.init
        ; sentences 5 i j in
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
    let linewidth = 0.01 in
    let radius = 0.1 in
    let (surface, context, dimensions) = D.initialize resolution i j in
    D.antialias context
    ; D.background context dimensions white
    ; D.scale context dimensions
    ; L.iter
        (fun points'' ->
            D.dots context points'' (linewidth /. 5.0) radius black
            ; D.lines context (S.spline points'' 4 100) linewidth black)
        points'
    ; D.export surface Y.argv.(4)

let () = main ()
