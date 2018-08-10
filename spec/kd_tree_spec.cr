require "./spec_helper"

describe Kd::Tree do
  points = [[2.0, 3.0], [5.0, 4.0]]

  it "#initialize" do
    kd_tree = Kd::Tree.new(points)
    kd_tree.should be_a(Kd::Tree)
  end

  describe "two-dimensional array" do
    points = [
      [2.0, 3.0],
      [5.0, 4.0],
      [4.0, 7.0],
      [7.0, 2.0],
      [8.0, 1.0],
      [9.0, 6.0],
    ]
    kd_tree = Kd::Tree.new(points)

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
    kd_tree = Kd::Tree.new(points)

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
