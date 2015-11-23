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
  (1..size).each do |x|
    tree.insert(x)
  end
end

time("searching with tree") do
  (1..size).each do |x|
    tree.find(x)
    tree.find(x + 0.5)
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