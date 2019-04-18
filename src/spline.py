#!/usr/bin/env python3

# exact rip off of https://github.com/thibauts/b-spline

from os import environ

from matplotlib.pyplot import close, subplots, savefig, tight_layout


def interpolate(t, degree, points):
    n = len(points)
    if (degree < 1) or (degree >= n):
        raise ValueError("0 < degree < n points")
    d = len(points[0])
    knots = list(range(n + degree + 1))
    weights = [1] * n
    domain = [degree, len(knots) - 1 - degree]
    low = knots[domain[0]]
    high = knots[domain[1]]
    t = t * (high - low) + low
    if (t < low) or (t > high):
        raise ValueError("t out of bounds")
    for s in range(*domain):
        if (t >= knots[s]) and (t <= knots[s + 1]):
            break
    f = lambda i, j: points[i][j] * weights[i] if j != d else weights[i]
    v = [[f(i, j) for j in range(d + 1)] for i in range(n)]
    for l in range(1, degree + 1):
        for i in range(s, (s - degree - 1 + l), -1):
            alpha = (t - knots[i]) / (knots[i + degree + 1 - l] - knots[i])
            for j in range(d + 1):
                v[i][j] = (1 - alpha) * v[i - 1][j] + alpha * v[i][j]
    result = [v[s][i] / v[s][d] for i in range(d)]
    return result


def transpose(xs):
    return zip(*xs)


def plot(xs, ys):
    _, ax = subplots()
    ax.scatter(*transpose(xs))
    ax.plot(*transpose(ys))
    tight_layout()
    savefig("{}/pngs/plot.png".format(environ["WD"]))
    close()


def spline(t, degree, points):
    return map( lambda t: interpolate(t, degree, points)
              , map(lambda x: x / t, range(0, t + 1, 1))
              )


def main():
    t = 100
    points = \
        [ [-0.5, 3]
        , [-1, 0]
        , [0.5, -0.5]
        , [0, 2]
        , [1, 0]
        , [-0.5, 0.5]
        , [-1, 0]
        , [-1, -1]
        ]
    degree = 2
    plot(points, spline(t, degree, points))


if __name__ == "__main__":
    main()
