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
  getter size = 2 # Assuming all GeoLocation objects are 2-dimensional

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

### Distance

For distance calculations, the squared Euclidean distance is used. However, you can easily monkey-patch the `Kd::Tree#distance` method to implement another algorithm, such as the Haversine formula, to calculate distances between two points given their latitudes and longitudes.

```crystal
require "haversine"

module Kd
  class Tree(T)
    private def distance(m : T, n : T)
      # Calling `Haversine.distance` with 2 pairs of latitude/longitude coordinates.
      # Returns a distance in meters.
      Haversine.distance({m.latitude, m.longitude}, {n.latitude, n.longitude}).to_meters
    end
  end
end

points = [
  GeoLocation.new("New York", -73.935242, 40.730610),
  GeoLocation.new("Los Angeles", -118.243683, 34.052235),
  GeoLocation.new("London", -0.127647, 51.507322),
  GeoLocation.new("Tokyo", 139.691711, 35.689487),
]

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
                        user     system      total        real
build(init)         1.840140   0.021103   1.861243 (  1.872732)
nearest point   1   0.004484   0.000002   0.004486 (  0.004490)
nearest point   5   0.007391   0.000010   0.007401 (  0.007479)
nearest point  10   0.011406   0.000090   0.011496 (  0.011679)
nearest point  50   0.034097   0.000819   0.034916 (  0.035175)
nearest point 100   0.133828   0.003721   0.137549 (  0.156548)
nearest point 255   0.220200   0.000631   0.220831 (  0.223081)
nearest point 999   0.731941   0.000441   0.732382 (  0.737236)
```

## Contributing

1. Fork it (<https://github.com/geocrystal/kd_tree/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [mamantoha](https://github.com/mamantoha) Anton Maminov - creator, maintainer
