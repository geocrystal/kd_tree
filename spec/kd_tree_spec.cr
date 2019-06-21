require "./spec_helper"

describe Kd::Tree do
  describe "#initialize" do
    it "with Float64" do
      points = [[2.0, 3.0], [5.0, 4.0]]

      kd_tree = Kd::Tree(Float64).new(points)
      kd_tree.should be_a(Kd::Tree(Float64))
    end

    it "with Int32" do
      points = [[2, 3], [5, 4]]

      kd_tree = Kd::Tree(Int32).new(points)
      kd_tree.should be_a(Kd::Tree(Int32))
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
      kd_tree = Kd::Tree(Int32).new(points)

      it "#nearest one" do
        res = kd_tree.nearest([1, 1])
        res.should eq([[2, 3]])
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
    kd_tree = Kd::Tree(Float64).new(points)

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
    kd_tree = Kd::Tree(Float64).new(points)

    it "#nearest one" do
      res = kd_tree.nearest([1.0, 1.0, 0.0])
      res.should eq([[2.0, 3.0, 0.0]])
    end

    it "#nearest many" do
      res = kd_tree.nearest([1.0, 1.0, 0.0], 2)
      res.should eq([[2.0, 3.0, 0.0], [5.0, 4.0, 0.0]])
    end
  end
end
