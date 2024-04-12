require "haversine"
require "../src/kd_tree"

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

module Kd
  class Tree(T)
    private def distance(m : T, n : T)
      # Calling `Haversine.distance` with 2 pairs of latitude/longitude coordinates.
      # Returns a distance in meters.
      Haversine.distance({m.latitude, m.longitude}, {n.latitude, n.longitude}).to_meters
    end
  end
end

# Example Usage:
# Create an array of GeoLocation points
points = [
  GeoLocation.new("New York", -73.935242, 40.730610),
  GeoLocation.new("Los Angeles", -118.243683, 34.052235),
  GeoLocation.new("London", -0.127647, 51.507322),
  GeoLocation.new("Paris", 2.349014, 48.864716),
  GeoLocation.new("Tokyo", 139.691711, 35.689487),
]

# Initialize the KD-tree with these points
kd_tree = Kd::Tree(GeoLocation).new(points)

# Find the nearest point to London
target = GeoLocation.new("Near London", -0.125740, 51.508530)
nearest_point = kd_tree.nearest(target, 3)
puts "First: #{nearest_point[0].name} (longitude #{nearest_point[0].longitude}, latitude #{nearest_point[0].latitude})"
puts "Second: #{nearest_point[1].name} (longitude #{nearest_point[1].longitude}, latitude #{nearest_point[1].latitude})"
puts "Third: #{nearest_point[2].name} (longitude #{nearest_point[2].longitude}, latitude #{nearest_point[2].latitude})"
