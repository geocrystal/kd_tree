# Kd::Tree

[![Crystal CI](https://github.com/geocrystal/kd_tree/actions/workflows/crystal.yml/badge.svg)](https://github.com/geocrystal/kd_tree/actions/workflows/crystal.yml)
[![GitHub release](https://img.shields.io/github/release/geocrystal/kd_tree.svg)](https://github.com/geocrystal/kd_tree/releases)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://geocrystal.github.io/kd_tree/)
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

`crystal run benchmark/benchmark.cr --release`

```console
Benchmarking KD-Tree with 1 million points
build(init): 3.41 seconds
                        user     system      total        real
nearest point   1   0.000019   0.000000   0.000019 (  0.000019)
nearest point   5   0.000021   0.000000   0.000021 (  0.000021)
nearest point  10   0.000025   0.000001   0.000026 (  0.000025)
nearest point  50   0.000269   0.000002   0.000271 (  0.000272)
nearest point 100   0.000809   0.000000   0.000809 (  0.000812)
nearest point 255   0.005078   0.000000   0.005078 (  0.005087)
nearest point 999   0.439598   0.000001   0.439599 (  0.440699)
```

## Contributing

1. Fork it (<https://github.com/geocrystal/kd_tree/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [mamantoha](https://github.com/mamantoha) Anton Maminov - creator, maintainer
