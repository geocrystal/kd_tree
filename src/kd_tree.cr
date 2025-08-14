require "priority-queue"
require "./kd_tree/*"

module Kd
  # A generic KD-tree implementation where `T` is the type of the points.
  class Tree(T)
    # Represents a node in the KD-tree. Each node stores a pivot point,
    # the axis it splits, and references to its left and right children.
    class Node(T)
      getter pivot : T, split : Int32, left : Node(T)?, right : Node(T)?

      def initialize(@pivot : T, @split : Int32, @left : self?, @right : self?)
      end
    end

    getter root : Node(T)? # The root node of the KD-tree
    @k : Int32             # Dimensionality of the points

    # Constructor for the KD-tree. Takes an array of points of type T and builds the tree.
    def initialize(points : Array(T))
      @k = points.first.size # Assumes all points have the same dimension
      @root = build_tree(points, 0)
    end

    # Recursive method to build the KD-tree from a given list of points.
    private def build_tree(points : Array(T), depth : Int32) : Node(T)?
      return if points.empty?

      axis = depth % @k         # Determine the axis to split on based on the current depth
      points.sort_by!(&.[axis]) # Sort points by the current axis
      median = points.size // 2 # Find the median index

      right_subtree = build_tree(points[median + 1..], depth + 1)
      left_subtree = build_tree(points[...median], depth + 1)

      # Create a new Node with the median point as pivot, and recursively build the left and right subtrees.
      Node(T).new(
        points[median],
        axis,
        left_subtree,
        right_subtree,
      )
    end

    # Method to find the nearest 'n' points to a given target point. Returns an array of these points.
    def nearest(target : T, n : Int32 = 1) : Array(T)
      return [] of T if n < 1

      best_nodes = Priority::Queue(Node(T)).new # Initialize a priority queue to store the best nodes found

      find_n_nearest(@root, target, 0, best_nodes, n) # Recursively find the nearest nodes

      best_nodes.map(&.value.pivot) # Extract the pivot points from the nodes and return them
    end

    # Recursive method to find the nearest nodes to a target point.
    private def find_n_nearest(
      node : Node(T)?,
      target : T,
      depth : Int32,
      best_nodes : Priority::Queue(Node(T)),
      n : Int32,
    )
      return unless node

      axis = depth % @k # Determine the axis to compare based on depth

      # Determine which child node to search next, prioritizing the side closer to the target
      next_node = target[axis] < node.pivot[axis] ? node.left : node.right
      other_node = target[axis] < node.pivot[axis] ? node.right : node.left

      # Recursively search the more likely side first
      find_n_nearest(next_node, target, depth + 1, best_nodes, n)

      # Calculate the distance from the target to the current node's pivot and add to the queue
      best_nodes.push(distance(target, node.pivot), node)

      # Ensure that only the 'n' closest nodes are kept in the queue
      best_nodes.pop if best_nodes.size > n

      # Check if the other side might contain closer points and potentially search there too
      if other_node && (best_nodes.size < n || (target[axis] - node.pivot[axis]).abs ** 2 < distance(target, best_nodes.last.value.pivot))
        find_n_nearest(other_node, target, depth + 1, best_nodes, n)
      end
    end

    # Calculate squared Euclidean distance between two points of type T.
    private def distance(m : T, n : T) : Float64
      @k.times.sum { |i| (m[i] - n[i]) ** 2 }.to_f
    end
  end
end
