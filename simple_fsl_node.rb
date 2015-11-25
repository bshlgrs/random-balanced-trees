$RANDOM = Random.new(3)

class SimpleFSLNode
  include Comparable

  attr_accessor :value, :parent, :children

  def self.root
    SimpleFSLNode.new(nil)
  end

  def print(indentation = 0)
    puts "  " * indentation + self.value.inspect
    children.each { |child| child.print(indentation + 1) }
  end

  def initialize(value = nil)
    @value = value
    @parent = nil
    @children = []
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
    if other.is_a? SimpleFSLNode
      self.value <=> other.value
    else
      self.value <=> other    
    end
  end

  def find_predecessor(target_value)
    return nil if !is_root? && self > target_value

    @children.reverse_each do |child|
      if child <= target_value
        result = child.find_predecessor(target_value)
        return result.nil? ? self : result
      end
    end 

    self
  end

  def find(target_value)
    predecessor = find_predecessor(target_value)

    return predecessor if predecessor == target_value
    nil
  end

  def add(target_value)
    predecessor = find_predecessor(target_value)
    predecessor.add_node_on_right(SimpleFSLNode.new(target_value))

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

  def orphan_all_children!
    @children.each { |x| x.parent = nil }
    @children = []
  end

  def bubble_up
    while $RANDOM.rand < 0.5
      position = @parent.children.find_index(self)
      parent.children.drop(position + 1).each { |node| add_child(node) }

      @parent.children.pop(parent.children.length - position)

      if @parent.is_root?
        if @parent.children.length > 1
          nodes = parent.children.drop(1)
          first = parent.children.first
          parent.orphan_all_children!
          parent.add_child(first)
          nodes.each { |node| first.add_child(node) }
        end

        @parent.add_child(self)
        return
      else
        @parent = @parent.parent
        @parent.add_child(self)
      end
    end
  end
end