=begin
  This function will find out if a number is prime
  it will also print out the numbers the number is divisible by
=end
def prime(n)
  is_prime = true
  divisible = []
  for i in 2...n
    if n % i == 0
      is_prime = false
      divisible.push(i)
    end
  end
  if is_prime
    puts "#{n} is a prime number!"
  else
    puts "#{n} is not a prime number"
    puts "and is divisible by:"
    divisible.each() { |number| print "#{number} "}
  end
end

=begin
  This function will only find out if a number is prime
    and is faster than the previous method since the iterations
    will end after the first divisible number found
=end
def prime_fast(n)
  is_prime = true
  i = 2
  while is_prime == true && i < n
    if n % i == 0
      is_prime = false
    end
    i += 1
  end
  puts "#{n} is prime: #{is_prime}"
end

def choose(n)
  puts "1. Detailed Prime"
  puts "2. Fast Prime"
  print "Enter which to run (1 or 2): "
  choice = Integer(gets.chomp()) rescue nil
  if choice == 1
    prime(n)
  elsif choice == 2
    prime_fast(n)
  else
    puts "---ERROR--- Please enter 1 or 2."
    choose(n)
  end
end

def init()
  print "Enter a whole number greater than 1: "
  number = Integer(gets.chomp()) rescue nil
  if number == nil || number <= 1
    puts "---ERROR--- Please enter a valid number"
    init()
  else
    choose(number)
  end
end

init()