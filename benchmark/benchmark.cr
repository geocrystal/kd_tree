require "benchmark"
require "../src/kd_tree"

# Generate 1 million random points
points = Array.new(1_000_000) { [rand * 100.0, rand * 100.0] }

puts "Benchmarking KD-Tree with 1 million points"
tree = nil
build_time = Benchmark.measure {
  tree = Kd::Tree(Array(Float64)).new(points)
}

puts "build(init): #{build_time.total.round(2)} seconds"

tree = tree.not_nil!

# Define a test point to find nearest neighbors for
test_point = [50.0, 50.0]

Benchmark.bm do |x|
  [1, 5, 10, 50, 100, 255, 999].each do |n|
    x.report("nearest point #{n.to_s.rjust(3, ' ')}") do
      tree.not_nil!.nearest(test_point, n)
    end
  end
end
