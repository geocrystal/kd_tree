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

For example, construct a new tree where each point is represented as a two-dimensional array in the form [x, y], where x and y are numbers (such as Int32, Float64, etc).

```crystal
kd = Kd::Tree(Array(Int32)).new(points)
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

kd = Kd::Tree(Array(Float64)).new(points)

kd.nearest([1.0, 1.0])
# => [[2.0, 3.0]])

kd_tree.nearest([1.0, 1.0], 2)
# => [[2.0, 3.0], [5.0, 4.0]])
```

### Complex objects

`Kd::Tree(T)` can accept any object that responds to `#size` and `#[](i : Int)` methods.

```crystal
class GeoLocation
  property name : String
  property longitude : Float64
  property latitude : Float64

  def initialize(@name : String, @longitude : Float64, @latitude : Float64)
  end

  # Define an indexer to allow easy access by index for longitude and latitude
  def [](index : Int32) : Float64
    case index
    when 0 then @longitude
    when 1 then @latitude
    else        raise "Index out of bounds"
    end
  end

  # Assuming all GeoLocation objects are 2-dimensional
  def size
    2
  end
end

# Create an array of GeoLocation points
points = [
  GeoLocation.new("New York", -73.935242, 40.730610),
  GeoLocation.new("Los Angeles", -118.243683, 34.052235),
  GeoLocation.new("London", -0.127647, 51.507322),
  GeoLocation.new("Tokyo", 139.691711, 35.689487),
]

# Initialize the KD-tree with these points
kd_tree = Kd::Tree(GeoLocation).new(points)

# Find the nearest point to London
target = GeoLocation.new("Near London", -0.125740, 51.508530)
nearest_point = kd_tree.nearest(target, 1)
puts "Nearest to London: #{nearest_point.first.name} (longitude #{nearest_point.first.longitude}, latitude #{nearest_point.first.latitude})"
# Nearest to London: London (longitude -0.127647, latitude 51.507322)
```

## Performance

Using a tree with 1 million points `[x, y] of Float64` on my i7-8550U CPU @ 1.80GHz:

`crystal run benchmark/benchmark.cr --release`

```console
Benchmarking KD-Tree with 1 million points
build(init): 4.34 seconds
                        user     system      total        real
nearest point   1   0.000017   0.000001   0.000018 (  0.000017)
nearest point   5   0.000022   0.000000   0.000022 (  0.000022)
nearest point  10   0.000021   0.000001   0.000022 (  0.000022)
nearest point  50   0.000058   0.000001   0.000059 (  0.000059)
nearest point 100   0.000087   0.000002   0.000089 (  0.000089)
nearest point 255   0.000248   0.000005   0.000253 (  0.000254)
nearest point 999   0.001033   0.000020   0.001053 (  0.001055)
```

## Contributing

1. Fork it (<https://github.com/geocrystal/kd_tree/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [mamantoha](https://github.com/mamantoha) Anton Maminov - creator, maintainer
