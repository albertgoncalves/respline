module A = Array
module L = List
module U = Utils

let (|.) = U.(|.)

let interpolate (points : float list list) (degree : int) (t : float)
        : float list =
    (* rip off of https://github.com/thibauts/b-spline *)
    let points' : float array array = L.map A.of_list points |> A.of_list in
    let n : int = A.length points' in
    if n <= degree then
        []
    else
        let d : int = A.length points'.(0) in
        if (A.exists (fun point -> A.length point <> d) points') then
            []
        else
            let knots : float array = A.init (n + degree + 1) float_of_int in
            let domain : int = (A.length knots) - 1 - degree in
            let low : float = knots.(degree) in
            let high : float = knots.(domain) in
            let t' : float = t *. (high -. low) +. low in
            if (t' < low) || (t' > high) then
                []
            else
                let s : int =
                    L.find
                        (fun s -> (t' >= knots.(s)) && (t' <= knots.(s + 1)))
                        (U.range degree domain) in
                let v : float array array =
                    A.init n (fun i ->
                        A.init (d + 1) (fun j ->
                            if j <> d then
                                points'.(i).(j)
                            else
                                1.0)) in
                for l = 1 to degree do
                    for i = s downto (s - degree + l) do
                        let alpha : float =
                            let k : float = knots.(i) in
                            (t' -. k) /. (knots.(i + degree + 1 - l) -. k) in
                        for j = 0 to d do
                            let x : float =
                                ((1.0 -. alpha) *. v.(i - 1).(j))
                                +. (alpha *. v.(i).(j)) in
                            A.set v.(i) j x
                        done
                    done
                done
                ; L.init d (fun i -> v.(s).(i) /. v.(s).(d))

let spline (points : float list list) (degree : int)
        : (int -> float list list) =
    L.map (interpolate points degree) |. U.slice |. (( * ) (L.length points))
