#!/usr/bin/env python3

from os import environ

from matplotlib.pyplot import close, subplots, savefig, tight_layout


def interpolate(t, degree, points, knots=None, weights=None, result=None):
    n = len(points)
    d = len(points[0])
    if degree < 1:
        raise ValueError("degree must be at least 1 (linear)")
    if degree > (n - 1):
        raise ValueError("degree must be less than or equal to point count -1")
    if weights is None:
        weights = [1] * n
    if knots is None:
        knots = list(range(n + degree + 1))
    else:
        if len(knots) != (n + degree + 1):
            raise ValueError("knot length does not equal (n + degree + 1)")
    domain = [degree, len(knots) - 1 - degree]
    low = knots[domain[0]]
    high = knots[domain[1]]
    t = t * (high - low) + low
    if (t < low) or (t > high):
        raise ValueError("t out of bounds")
    for s in range(*domain):
        if (t >= knots[s]) and (t <= knots[s + 1]):
            break
    vs = []
    for i in range(n):
        v = []
        for j in range(d):
            v.append(points[i][j] * weights[i])
        v.append(weights[i])
        vs.append(v)
    for l in range(1, degree + 1):
        i = s
        for i in range(s, (s - degree - 1 + l), -1):
            alpha = (t - knots[i]) / (knots[i + degree + 1 - l] - knots[i])
            for j in range(d + 1):
                vs[i][j] = (1 - alpha) * vs[i - 1][j] + alpha * vs[i][j]
    if result is None:
        result = []
    for i in range(d):
        result.append(vs[s][i] / vs[s][d])
    return result


def plot(x, y, i):
    _, ax = subplots()
    ax.scatter(*zip(*x))
    ax.plot(*zip(*y))
    tight_layout()
    savefig("{}/pngs/{}.png".format(environ["WD"], i))
    close()


def main():
    z = 100
    ts = list(map(lambda x: x / z, range(0, z + 1, 1)))
    degree = 2
    x = \
        [ [-1.0,  0.0]
        , [-0.5,  0.5]
        , [ 0.5, -0.5]
        , [ 1.0,  0.0]
        ]
    interpolate_ = lambda knots: lambda t: interpolate(t, degree, x, knots)
    ys = map( lambda knots: map(interpolate_(knots), ts)
            , [None, [0, 0, 0, 1, 2, 2, 2]]
            )
    for i, y in enumerate(ys):
        plot(x, y, i)


if __name__ == "__main__":
    main()
