module A = Array
module L = List

let ts (n : int) = L.init (n + 1) (fun x -> float_of_int x /. float_of_int n)

let range (a : int) (b : int) : int list =
    if b > a then
        L.init (b - a) (fun x -> x + a)
    else
        L.init (a - b) (fun x -> a - x)

let interpolate (points : float list list) (t : float) : float list =
    (* rip off of https://github.com/thibauts/b-spline *)
    let points' : float array array = L.map A.of_list points |> A.of_list in
    let degree : int = 2 in
    let n : int = A.length points' in
    if n <= degree then
        []
    else
        let d : int = A.length points'.(0) in
        if (A.exists (fun point -> A.length point <> d) points') then
            []
        else
            let knots : float array =
                A.init (n + degree + 1) float_of_int in
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
                        (range degree degree') in
                let v : float array array =
                    let f (i : int) : float array =
                        A.init
                            (d + 1)
                            begin
                                fun j ->
                                    if j <> d then points'.(i).(j) else 1.0
                            end in
                    (A.init n f) in
                for l = 1 to degree do
                    for i = s downto (s - degree + l) do
                        let alpha : float =
                            (t' -. knots.(i))
                            /. (knots.(i + degree + 1 - l) -. knots.(i)) in
                        for j = 0 to d do
                            let x : float =
                                ((1.0 -. alpha) *. v.(i - 1).(j))
                                +. (alpha *. v.(i).(j)) in
                            A.set v.(i) j x
                        done
                    done
                done;
                L.init d (fun i -> v.(s).(i) /. v.(s).(d))
