require "./spec_helper"

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

describe Kd::Tree do
  describe "#initialize" do
    it "with Float64" do
      points = [[2.0, 3.0], [5.0, 4.0]]

      kd_tree = Kd::Tree(Array(Float64)).new(points)
      kd_tree.should be_a(Kd::Tree(Array(Float64)))
    end

    it "with Int32" do
      points = [[2, 3], [5, 4]]

      kd_tree = Kd::Tree(Array(Int32)).new(points)
      kd_tree.should be_a(Kd::Tree(Array(Int32)))
    end
  end

  describe "two-dimensional array" do
    describe "with Int32" do
      points = [
        [2, 3],
        [5, 4],
        [4, 7],
        [7, 2],
        [8, 1],
        [9, 6],
      ]
      kd_tree = Kd::Tree(Array(Int32)).new(points)

      it "#nearest one" do
        res = kd_tree.nearest([1, 1])
        res.should eq([[2, 3]])
      end
    end

    describe "with negative" do
      points = [
        [-1, -1],
        [0, 0],
        [5, 4],
        [4, 7],
        [7, 2],
        [8, 1],
        [9, 6],
      ]
      kd_tree = Kd::Tree(Array(Int32)).new(points)

      it "#nearest one" do
        res = kd_tree.nearest([-2, -2])
        res.should eq([[-1, -1]])
      end
    end

    points = [
      [2.0, 3.0],
      [5.0, 4.0],
      [4.0, 7.0],
      [7.0, 2.0],
      [8.0, 1.0],
      [9.0, 6.0],
    ]
    kd_tree = Kd::Tree(Array(Float64)).new(points)

    it "have root" do
      kd_tree.root.should_not eq(nil)
    end

    it "#nearest one" do
      res = kd_tree.nearest([1.0, 1.0])
      res.should eq([[2.0, 3.0]])
    end

    it "#nearest many" do
      res = kd_tree.nearest([1.0, 1.0], 2)
      res.should eq([[2.0, 3.0], [5.0, 4.0]])
    end

    it "#nearest too many" do
      res = kd_tree.nearest([1.0, 1.0], 100)
      res.size.should eq(points.size)
    end
  end

  describe "tree-dimensional array" do
    points = [
      [2.0, 3.0, 0.0],
      [5.0, 4.0, 0.0],
      [4.0, 7.0, 0.0],
      [7.0, 2.0, 0.0],
      [8.0, 1.0, 0.0],
      [9.0, 6.0, 0.1],
    ]
    kd_tree = Kd::Tree(Array(Float64)).new(points)

    it "#nearest one" do
      res = kd_tree.nearest([1.0, 1.0, 0.0])
      res.should eq([[2.0, 3.0, 0.0]])
    end

    it "#nearest many" do
      res = kd_tree.nearest([1.0, 1.0, 0.0], 2)
      res.should eq([[2.0, 3.0, 0.0], [5.0, 4.0, 0.0]])
    end
  end

  describe "#nearest" do
    # https://github.com/geocrystal/kd_tree/issues/2
    it "should equal naive implementation" do
      ndim = 2
      k = 3
      distance = ->(m : Array(Float64), n : Array(Float64)) do
        m.each_with_index.reduce(0) do |sum, (coord, index)|
          sum += (coord - n[index]) ** 2
          sum
        end
      end

      10.times do
        points = Array.new(10) do
          Array.new(ndim) do
            rand(-10.0..10.0)
          end
        end
        kd_tree = Kd::Tree(Array(Float64)).new(points)
        target = Array.new(ndim) do
          rand(-11.0..11.0)
        end
        res = kd_tree.nearest(target, k)
        sorted = points.sort_by do |p|
          distance.call(p, target)
        end.reverse!
        (res - sorted[-k..]).should eq [] of Float64
      end
    end
  end

  describe "complex object" do
    # Create an array of GeoLocation points
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
    nearest_point.first.name.should eq("London")
  end
end
