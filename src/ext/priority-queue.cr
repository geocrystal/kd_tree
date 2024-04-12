require "priority-queue"

module Priority
  class Item(V)
    def initialize(@priority : Float64, @value : V, name = nil)
      @name = name.to_s if name
    end
  end

  class Queue(V)
    def push(priority : Float64, value : V, name = nil)
      item = Item(V).new(priority, value, name)
      push(item)
    end
  end
end
