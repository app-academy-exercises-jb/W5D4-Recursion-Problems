#Problem 1: 

def sum_recur(array)
  array.empty? ? 0 : (array.shift + sum_recur(array))
end

#Problem 2: 

def includes?(array, target)
  array.empty? ? (return false) : (array.shift == target ? (return true) : includes?(array, target))
end

# Problem 3: 

def num_occur(array, target)
  count = 0
  return count if array.empty?
  count += 1 if target == array.shift
  count += num_occur(array,target)
  count
end

# Problem 4: 

def add_to_twelve?(array)
  return false if array.length < 2
  first, second = array.shift, array[0]
  return true if first + second == 12
  add_to_twelve?(array)
end

# Problem 5: 

def sorted?(array)
  return true if array.length <= 1
  return false if array.shift > array[0]
  sorted?(array)
end

# Problem 6: 

def reverse(string)
  new_str = ""
  return new_str if string == ""
  new_str += string[-1]
  new_str += reverse(string[0..-2])
  new_str
end
