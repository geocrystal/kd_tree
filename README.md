# Kd::Tree

[![GitHub release](https://img.shields.io/github/release/geocrystal/kd_tree.svg)](https://github.com/geocrystal/kd_tree/releases)
[![License](https://img.shields.io/github/license/geocrystal/kd_tree.svg)](https://github.com/geocrystal/kd_tree/blob/master/LICENSE)

Crystal implementation of "K-Dimensional Tree" and "N-Nearest Neighbors"
based on <http://en.wikipedia.org/wiki/Kd-tree>.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  kd_tree:
    github: geocrystal/kd_tree
```

## Usage

```crystal
require "kd_tree"
```

Construct a new tree. Each point should be of the form `[x, y]`, where `x` and `y` are numbers(`Int32`, `Float64`, etc):

```crystal
kd = Kd::Tree(Int32).new(points)
```

Find the nearest point to `[x, y]`. Returns an array with one point:

```crystal
kd.nearest([x, y])
```

Find the nearest `k` points to `[x, y]`. Returns an array of points:

```crystal
kd.nearest([x, y], k)
```

## Example

```crystal
require "kd_tree"

points = [
  [2.0, 3.0],
  [5.0, 4.0],
  [4.0, 7.0],
  [7.0, 2.0],
  [8.0, 1.0],
  [9.0, 6.0],
]

kd = Kd::Tree(Float64).new(points)

kd.nearest([1.0, 1.0])
# => [[2.0, 3.0]])

kd_tree.nearest([1.0, 1.0], 2)
# => [[2.0, 3.0], [5.0, 4.0]])
```

## Performance

Using a tree with 1 million points `[x, y] of Float64` on my i7-8550U CPU @ 1.80GHz:

```console
build(init)       ~10 seconds
nearest point     00.000278579
nearest point 5   00.000693038
nearest point 50  00.007207470
nearest point 255 00.134533902
nearest point 999 08.510465131
```

## Contributing

1. Fork it (<https://github.com/geocrystal/kd_tree/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [mamantoha](https://github.com/mamantoha) Anton Maminov - creator, maintainer
