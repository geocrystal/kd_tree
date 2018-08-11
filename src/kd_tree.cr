require "./kd_tree/*"

module Kd
  alias Point = Array(Float64)

  class Node
    getter pivot, split, left, right

    def initialize(
      @pivot : Point,
      @split : Int32,
      @left : self?,
      @right : self?
    )
    end
  end

  class Tree
    getter root

    @root : Node?
    @k : Int32

    def initialize(points : Array(Point), depth = 0)
      @k = points.first.size # assumes all points have the same dimension
      @root = build(points, depth)
    end

    def nearest(query : Point)
      nearest(query, 1)
    end

    def nearest(query : Point, n : Int32)
      nearest!(@root, query, [] of Point, n)
    end

    private def nearest!(
      curr : Node?,
      query : Point,
      nearest : Array(Point),
      n = 1
    )
      return nearest if curr.nil?

      # if the current node is better than any of the current nearest,
      # then it becomes a current nearest
      if nearest.size < n
        nearest << curr.pivot
      else
        dist_curr_query = distance(curr.pivot, query)
        ix = nearest.index { |b| dist_curr_query < distance(b, query) }
        nearest[ix] = curr.pivot if ix
      end

      # determine which branch contains the query along the split dimension
      nearer, farther = if query[curr.split] <= curr.pivot[curr.split]
                          [curr.left, curr.right]
                        else
                          [curr.right, curr.left]
                        end

      # search the nearer branch
      nearest = nearest!(nearer, query, nearest, n)

      # search the farther branch if the distance to the hyperplane is less
      # than any nearest so far
      dist_curr_query_spldim = distance(
        [curr.pivot[curr.split]],
        [query[curr.split]]
      )

      if nearest.find { |b| distance(b, query) >= dist_curr_query_spldim }
        nearest = nearest!(farther, query, nearest, n)
      end

      # else no need to search the entire farther branch i.e. prune!
      nearest
    end

    private def distance(m : Point, n : Point)
      # squared euclidean distance (to avoid expensive sqrt operation)
      m.each_with_index.reduce(0) do |sum, (coord, index)|
        sum += (coord - n[index]) ** 2
      end
    end

    private def build(points : Array(Point), depth = 0)
      return if points.empty?

      # Select axis based on depth so that axis cycles through all valid values
      axis = depth % @k

      # Sort point list and choose median as pivot element
      points.sort! { |m, n| m[axis] <=> n[axis] }
      pivot = points.size / 2

      # Create node and construct subtrees
      Node.new(
        points[pivot],
        axis,
        build(points[0...pivot], depth + 1),
        build(points[pivot + 1..-1], depth + 1)
      )
    end
  end
end
