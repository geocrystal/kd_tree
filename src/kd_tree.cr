require "./kd_tree/*"

module Kd
  class Tree(T)
    class Node(T)
      getter pivot, split, left, right

      def initialize(
        @pivot : Array(T),
        @split : Int32,
        @left : self?,
        @right : self?
      )
      end
    end

    getter root : Node(T)?
    @k : Int32

    def initialize(points : Array(Array(T)))
      @k = points.first.size # assumes all points have the same dimension
      @root = build_tree(points, 0)
    end

    def nearest(target : Array(T), n : Int32 = 1) : Array(Array(T))
      return [] of Array(T) if n < 1

      best_nodes = Array(Node(T)).new

      find_n_nearest(@root, target, 0, best_nodes, n)

      best_nodes.map(&.pivot)
    end

    private def find_n_nearest(
      node : Node(T)?,
      target : Array(T),
      depth : Int32,
      best_nodes : Array(Node(T)),
      n : Int32
    )
      return unless node

      axis = depth % @k

      next_node = target[axis] < node.pivot[axis] ? node.left : node.right
      other_node = target[axis] < node.pivot[axis] ? node.right : node.left

      find_n_nearest(next_node, target, depth + 1, best_nodes, n)

      if best_nodes.size < n || distance(target, node.pivot) < distance(target, best_nodes.last.pivot)
        best_nodes << node
        best_nodes.sort_by! { |nd| distance(target, nd.pivot) }
        best_nodes.pop if best_nodes.size > n
      end

      if other_node && (best_nodes.size < n || (target[axis] - node.pivot[axis]).abs**2 < distance(target, best_nodes.last.pivot))
        find_n_nearest(other_node, target, depth + 1, best_nodes, n)
      end
    end

    private def distance(m : Array(T), n : Array(T))
      # squared euclidean distance (to avoid expensive sqrt operation)
      m.each_with_index.sum do |coord, index|
        (coord - n[index]) ** 2
      end
    end

    private def build_tree(points : Array(Array(T)), depth : Int32) : Node(T)?
      return if points.empty?

      axis = depth % @k
      points.sort_by! { |point| point[axis] }
      median = points.size // 2

      # Create node and construct subtrees
      Node(T).new(
        points[median],
        axis,
        build_tree(points[0...median], depth + 1),
        build_tree(points[median + 1..], depth + 1)
      )
    end
  end
end
