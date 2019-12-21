require "byebug"

def range(i, j)
  i < j ? [i].concat(range(i + 1, j)) : []  
end

def exponent_one(b, n)
  return 1 if n == 0

  b * exponent_one(b, n-1)
end

def exponent_two(b, n)
  return 1 if n == 0
  return b if n == 1

  if n.even?
    exponent_two(b, n/2) * exponent_two(b, n/2)    
  else
    b * exponent_two( exponent_two(b, (n-1)/2) , 2)
  end
end

class Array
  def deep_dup
    self.map { |ele| ele.is_a?(Array) ? ele.deep_dup : ele.dup }
  end
end

# fibonacci(1) => [1]
# fibonacci(2) => [1,1]
# fibonacci(3) => [1,1,2]
# fibonacci(4) => [1,1,2,3]
def fibonacci(n)
  return [n] if n == 1
  return [1, 1].take(n) if n <= 2

  prev_fib = fibonacci(n-1)
  last_num = prev_fib[-1]
  two_nums_ago = prev_fib[-2]
  
  next_num = last_num + two_nums_ago

  prev_fib.push(next_num)
end


# bsearch([1, 2, 3], 1) # => 0
# bsearch([2, 3, 4, 5], 3) # => 1
# bsearch([2, 4, 6, 8, 10], 6) # => 2
# bsearch([1, 3, 4, 5, 9], 5) # => 3
# bsearch([1, 2, 3, 4, 5, 6], 6) # => 5
# bsearch([1, 2, 3, 4, 5, 6], 0) # => nil
# bsearch([1, 2, 3, 4, 5, 7], 6) # => nil

def bsearch(array, target) 
  index = array.length/2 # 1

  dif = target <=> array[index] # -1
  
  return 0 if array.empty?

  if dif == 0
    return index
  elsif dif == -1 
    bsearch(array[0...index], target)
  elsif dif == 1 
    array.length.even? ? 
      index + 1 + bsearch(array[index + 1..-1], target) : 
      index + bsearch(array[index + 1..-1], target)
  end

end


def merge_sort(array)
  # base case
  case array.length 
  when 0..1
    return array
  else
    first_half = merge_sort(array[0...array.length/2])
    second_half = merge_sort(array[array.length/2..-1])
    
    sorted = []
    
    until first_half.empty? || second_half.empty?
      if (first_half[0] <=> second_half[0]) == -1
        sorted << first_half.shift
      else
        sorted << second_half.shift
      end
    end

    sorted + first_half + second_half
  end
end

def subsets(array)
  return [] if array == []
  return [array] unless array.is_a?(Array)

  combobs = []

  array[0..-2].each_with_index { |ele,idx| 
    array[idx+1..-1].each_with_index { |ele2, idx2|
      combobs << [ele, ele2]
    }
  }
  combobs << array
  
  [subsets(array[0])] | combobs | subsets(array[1..-1]) + [[]]
end

def permutations(array,jdx=0)
  return [] if jdx == array.length
  perms = []
  array.each_with_index { |ele,idx|
    perms << array.dup
    array[idx], array[jdx] = array[jdx], array[idx]
    perms = perms | permutations(array,jdx+1)
  } 
  perms
end


def make_change(cash, coins_array, splinter=true)
  perms = permutations(coins_array) if splinter == true
  coins_array = coins_array.dup
  changes = {}

  perms.each { |perm| 
    changes[perm] = make_change(cash, perm, false)
  } if splinter == true

  change = []
  until cash <= (change.reduce(:+) || 0) || coins_array.empty?
    change << coins_array[0]
    a = make_change(cash - change.reduce(:+), coins_array.sort.reverse, false)
    if a && (change + a).reduce(:+) == cash
      change += a
      break
    end
    coins_array.shift if coins_array[0] > (cash - change.reduce(:+))
  end

  if splinter == false
    if change.reduce(:+) == cash
      return change
    else
      return 
    end
  end
  
  # choose shortest change
  answer = changes.values.compact.sort_by! { |arr| arr.length }[0]
  answer.nil? ? (puts "no change") : answer.sort.reverse
end