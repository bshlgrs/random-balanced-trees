$RANDOM = Random.new(3)

require "./skip_list_tree.rb"


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
    tree.insert(x)
  end
end

# tree.print

time("searching with tree") do
  (1..size).to_a.shuffle.each do |x|
    fail if tree.find(x).nil?
    fail unless tree.find(x + 0.5).nil?
  end
end


arr = []

time("inserting with array") do
  (1..size).each do |x|
    arr << x
  end
end

time("searching with array") do
  (1..size).each do |x|
    arr.find_index(x)
    arr.find_index(x + 0.5)
  end
end