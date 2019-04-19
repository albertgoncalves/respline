module O = OUnit2
module OU = OUnitTest

let (>:::) = O.(>:::)
let (>::) = O.(>::)

let test_example (test_ctxt : O.test_ctxt) : unit =
    O.assert_equal true true

let suite : (OU.test) list =
    [ "example" >:: test_example
    ]

let main () = "suite" >::: suite |> O.run_test_tt_main

let () = main ()
