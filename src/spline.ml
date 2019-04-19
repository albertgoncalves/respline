module A = Array
module L = List

let range (f : (int -> (int -> int) -> 'a)) (a : int) (b : int) : 'b =
    if b > a then
        f (b - a) (fun x -> x + a)
    else
        f (a - b) (fun x -> a - x)

let interpolate (points : float list list) (t : float) : float list =
    let points' = L.map A.of_list points |> A.of_list in
    let degree : int = 2 in
    let n : int = A.length points' in
    if n <= degree then
        []
    else
        let d : int = points'.(0) |> A.length in
        if (A.exists (fun point -> A.length point <> d) points') then
            []
        else
            let knots : float array =
                range A.init 0 (n + degree + 1) |> A.map float_of_int in
            let degree' : int = (A.length knots) - 1 - degree in
            let low : float = knots.(degree) in
            let high : float = knots.(degree') in
            let t' : float = t *. (high -. low) +. low in
            if (t' < low) || (t' > high) then
                []
            else
                let s : int =
                    L.find
                        (fun s -> (t' >= knots.(s)) && (t' <= knots.(s + 1)))
                        (range L.init degree degree') in
                let v : float array array =
                    let f (i : int) : float array =
                        A.map
                            (fun j -> if j != d then points'.(i).(j) else 1.0)
                            (range A.init 0 (d + 1)) in
                    A.map f (range A.init 0 n) in
                for l = 1 to degree do
                    for i = s downto (s - degree + l) do
                        let alpha =
                            (t' -. knots.(i))
                            /. (knots.(i + degree + 1 - l) -. knots.(i)) in
                        for j = 0 to d do
                            let x =
                                (1.0 -. alpha) *. v.(i - 1).(j)
                                +. alpha *. v.(i).(j) in
                            A.set v.(i) j x
                        done
                    done
                done;
                L.map (fun i -> v.(s).(i) /. v.(s).(d)) (range L.init 0 d)
