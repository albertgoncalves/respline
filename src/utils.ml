module L = List

let (|.) (f : 'b -> 'c) (g : 'a -> 'b) : ('a -> 'c) = fun x -> f (g x)

let range (a : int) (b : int) : int list =
    if b > a then
        L.init (b - a) (fun x -> x + a)
    else
        L.init (a - b) (fun x -> a - x)

let slice (n : int) : float list =
    L.init (n + 1) (fun x -> float_of_int x /. float_of_int n)
