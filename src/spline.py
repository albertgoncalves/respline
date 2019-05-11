#!/usr/bin/env python3

from os import environ

from matplotlib.pyplot import close, savefig, subplots, tight_layout


def interpolate(points, degree):
    # rip off of https://github.com/thibauts/b-spline
    n = len(points)
    d = len(points[0])
    if n <= degree:
        raise ValueError("len(points) must be greater than 2")
    knots = list(range(n + degree + 1))
    domain = [degree, len(knots) - 1 - degree]
    low = knots[domain[0]]
    high = knots[domain[1]]
    def f(t):
        t = t * (high - low) + low
        if (t < low) or (t > high):
            raise ValueError("t out of bounds")
        for s in range(*domain):
            if (t >= knots[s]) and (t <= knots[s + 1]):
                break
        f_ = lambda i, j: points[i][j] if j != d else 1
        v = [[f_(i, j) for j in range(d + 1)] for i in range(n)]
        for l in range(1, degree + 1):
            for i in range(s, (s - degree - 1 + l), -1):
                alpha = (t - knots[i]) / (knots[i + degree + 1 - l] - knots[i])
                for j in range(d + 1):
                    v[i][j] = (1 - alpha) * v[i - 1][j] + alpha * v[i][j]
        return [v[s][i] / v[s][d] for i in range(d)]
    return f


def spline(points, degree, t):
    return map( interpolate(points, degree)
              , map(lambda x: x / t, range(0, t + 1, 1))
              )


def plot(xs, ys):
    _, ax = subplots(figsize=(8, 8), dpi=300)
    ax.scatter(*zip(*xs))
    ax.plot(*zip(*ys))
    ax.set_aspect("equal")
    tight_layout()
    savefig("{}/pngs/py.png".format(environ["WD"]))
    close()


def main():
    points = \
        [ [-0.5, 5]
        , [-2, 0]
        , [0.5, -0.5]
        , [0, 2]
        , [3.5, 0]
        , [-0.5, 0.5]
        , [-2, 0]
        , [-3, -1]
        , [2, -0.5]
        , [0, -2.75]
        , [5, -5]
        ]
    plot(points, spline(points, 4, 5000))


if __name__ == "__main__":
    main()
