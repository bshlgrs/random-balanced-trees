$RANDOM = Random.new

class FSLNode
  attr_accessor :value, :parent, :children, :properties

  def self.root
    FSLNode.new(nil)
  end

  def initialize(value = nil, **properties)
    @value = value
    @parent = nil
    @children = []
    @properties = properties || {}

    @ordering = @properties[:ordering]
  end

  def is_root?
    parent.nil?
  end

  def each(&blk)
    yield value unless is_root?

    children.each { |child| child.each(&blk) }
  end

  def to_a
    [].tap { |out| self.each { |x| out << x } }
  end

  def <=>(other)
    self.value <=> other.value
  end

  def find_predecessor(target_value)
    return self if @value == target_value # this line is technically unnecessary
    return nil if !is_root? && @value > target_value

    @children.reverse_each do |child|
      if child.value <= target_value
        result = child.find_predecessor(target_value)
        return result.nil? ? self : result
      end
    end 

    self
  end

  def find(target_value)
    predecessor = find_predecessor(target_value)

    return predecessor if predecessor.value == target_value
    nil
  end

  def insert(target_value)
    predecessor = find_predecessor(target_value)
    predecessor.add_node_on_right(FSLNode.new(target_value))

    self
  end

  def add_child(node)
    @children << node
    @children.sort!

    node.parent = self
  end

  def add_node_on_right(node)
    add_child(node)

    node.bubble_up
  end

  def bubble_up
    while $RANDOM.rand < 0.5
      position = parent.children.find_index(self)
      @children.push(* parent.children.drop(position + 1))
      @parent.children.pop(parent.children.length - position)

      if @parent.is_root?
        if @parent.children.length > 0
          nodes = parent.children.drop(1)
          @parent.children = [parent.children.first]
          nodes.each { |node| parent.children.first.add_child(node) }
        else
          @parent.children = []
        end

        @parent.add_child(self)
        return
      else
        @parent = parent.parent
        @parent.add_child(self)
      end
    end
  end
end