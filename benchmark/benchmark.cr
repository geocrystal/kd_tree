require "benchmark"
require "../src/kd_tree"

# Generate 1 million random points
points = Array.new(1_000_000) { [rand * 100.0, rand * 100.0] }

puts "Benchmarking KD-Tree with 1 million points"

Benchmark.bm do |x|
  tree = nil

  x.report("build(init)") {
    tree = Kd::Tree(Array(Float64)).new(points)
  }

  [1, 5, 10, 50, 100, 255, 999].each do |n|
    x.report("nearest point #{n.to_s.rjust(3, ' ')}") do
      1000.times do
        test_point = [rand * 100.0, rand * 100.0]

        tree.not_nil!.nearest(test_point, n)
      end
    end
  end
end
