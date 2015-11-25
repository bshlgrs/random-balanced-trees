$RANDOM = Random.new(3)

require "./fsl_node.rb"

def time(description)
  puts description
  start_time = Time.now
  yield
  puts "That took #{Time.now - start_time}"
end

tree = FSLNode.root
size = 10000

time("inserting with tree") do 
  (1..size).to_a.shuffle.each do |x|
    tree.add(x)
  end
end

puts "size is allegedly #{tree.size}"

time("random accessing the tree") do 
  (0...size).each do |x|
    fail unless tree[x] == x + 1
  end
end

time("searching with tree") do
  (1..size).to_a.shuffle.each do |x|
    fail if tree.find(x).nil?
    fail unless tree.find(x + 0.5).nil?
  end
end


puts "median is #{tree.median}"
fail unless tree.median == size / 2 + 1

if false
  arr = []

  time("inserting with array") do
    (1..size).to_a.shuffle.each do |x|
      arr << x
    end
  end

  time("searching with array") do
    (1..size).to_a.shuffle.each do |x|
      fail if arr.find_index(x).nil?
      fail unless arr.find_index(x + 0.5).nil?
    end
  end
end