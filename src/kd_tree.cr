require "./ext/priority-queue"
require "./kd_tree/*"

module Kd
  class Tree(T)
    class Node(T)
      getter pivot, split, left, right

      def initialize(@pivot : T, @split : Int32, @left : self?, @right : self?)
      end
    end

    getter root : Node(T)?
    @k : Int32

    def initialize(points : Array(T))
      @k = points.first.size # assumes all points have the same dimension
      @root = build_tree(points, 0)
    end

    private def build_tree(points : Array(T), depth : Int32) : Node(T)?
      return if points.empty?

      axis = depth % @k
      points.sort_by!(&.[axis])
      median = points.size // 2

      # Create node and construct subtrees
      Node(T).new(
        points[median],
        axis,
        build_tree(points[0...median], depth + 1),
        build_tree(points[median + 1..], depth + 1)
      )
    end

    def nearest(target : T, n : Int32 = 1) : Array(T)
      return [] of T if n < 1

      best_nodes = Priority::Queue(Node(T)).new

      find_n_nearest(@root, target, 0, best_nodes, n)

      best_nodes.map(&.value.pivot)
    end

    private def find_n_nearest(
      node : Node(T)?,
      target : T,
      depth : Int32,
      best_nodes : Priority::Queue(Node(T)),
      n : Int32
    )
      return unless node

      axis = depth % @k

      next_node = target[axis] < node.pivot[axis] ? node.left : node.right
      other_node = target[axis] < node.pivot[axis] ? node.right : node.left

      find_n_nearest(next_node, target, depth + 1, best_nodes, n)

      best_nodes.push(distance(target, node.pivot), node)

      best_nodes.pop if best_nodes.size > n

      if other_node && (best_nodes.size < n || (target[axis] - node.pivot[axis]).abs ** 2 < distance(target, best_nodes.last.value.pivot))
        find_n_nearest(other_node, target, depth + 1, best_nodes, n)
      end
    end

    private def distance(m : T, n : T)
      # squared euclidean distance (to avoid expensive sqrt operation)
      @k.times.sum { |i| (m[i] - n[i]) ** 2 }
    end
  end
end
