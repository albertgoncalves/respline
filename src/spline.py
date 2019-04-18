#!/usr/bin/env python3

# exact rip off of https://github.com/thibauts/b-spline

from os import environ

from matplotlib.pyplot import close, subplots, savefig, tight_layout


def interpolate(t, degree, points):
    n = len(points)
    d = len(points[0])
    knots = list(range(n + degree + 1))
    weights = [1] * n
    if degree < 1:
        raise ValueError("degree must be at least 1 (linear)")
    if degree > (n - 1):
        raise ValueError("degree must be less than or equal to point count -1")
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
    result = []
    for i in range(d):
        result.append(vs[s][i] / vs[s][d])
    return result


def plot(x, y):
    _, ax = subplots()
    ax.scatter(*zip(*x))
    ax.plot(*zip(*y))
    tight_layout()
    savefig("{}/pngs/plot.png".format(environ["WD"]))
    close()


def spline(t, degree, points):
    return map( lambda t: interpolate(t, degree, points)
              , map(lambda x: x / t, range(0, t + 1, 1))
              )


def main():
    t = 100
    degree = 2
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
    plot(points, spline(t, degree, points))


if __name__ == "__main__":
    main()
