module L = List
module O = OUnit2
module OU = OUnitTest
module S = Spline

let (>:::) = O.(>:::)
let (>::) = O.(>::)

let valid (_ : O.test_ctxt) : unit =
    let points : float list list =
        [ [-1.0; 0.0]
        ; [-0.5; 0.5]
        ; [0.5; -0.5]
        ; [1.0; 0.0]
        ] in
    let expected : string list list =
        [ ["-0.75"; "0.25"]
        ; ["-0.64"; "0.32"]
        ; ["-0.51"; "0.33"]
        ; ["-0.36"; "0.28"]
        ; ["-0.19"; "0.17"]
        ; ["0."; "0."]
        ; ["0.19"; "-0.17"]
        ; ["0.36"; "-0.28"]
        ; ["0.51"; "-0.33"]
        ; ["0.64"; "-0.32"]
        ; ["0.75"; "-0.25"]
        ] in
    let output = L.map (S.interpolate points) (S.ts 10) in
    O.assert_equal (L.map (L.map string_of_float) output) expected


let uneven_dimensions (_ : O.test_ctxt) : unit =
    let points : float list list =
        [ [-1.0; 0.0]
        ; [-0.5]
        ; [0.5; -0.5]
        ; [1.0; 0.0]
        ] in
    let output = L.map (S.interpolate points) (S.ts 1) in
    O.assert_equal output [[]; []]

let few_points (_ : O.test_ctxt) : unit =
    let points : float list list =
        [ [-1.0; 0.0]
        ; [-0.5; 0.5]
        ] in
    let output = L.map (S.interpolate points) (S.ts 1) in
    O.assert_equal output [[]; []]

let out_of_bounds (_ : O.test_ctxt) : unit =
    let points : float list list =
        [ [-1.0; 0.0]
        ; [-0.5; 0.5]
        ; [0.5; -0.5]
        ; [1.0; 0.0]
        ] in
    let output = L.map (S.interpolate points) [-0.1; 0.5; 1.1] in
    O.assert_equal output [[]; [0.0; 0.0]; []]

let suite : (OU.test) list =
    [ "valid" >:: valid
    ; "uneven_dimensions" >:: uneven_dimensions
    ; "few_points" >:: few_points
    ; "out_of_bounds" >:: out_of_bounds
    ]

let main () = "suite" >::: suite |> O.run_test_tt_main

let () = main ()
