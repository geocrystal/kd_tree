require "../src/kd_tree"

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

# Example Usage:
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
