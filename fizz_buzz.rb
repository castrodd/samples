# Multiples of 3 are "Fizz"
# Multiples of 5 are "Buzz"
# Multiples of 3 and 5 are "FizzBuzz"
# Otherwise the number itself will print

(1..100).each do |number|
  if number%3 == 0 && number%5 == 0
    puts "FizzBuzz"
  elsif number%3 == 0
    puts "Fizz"
  elsif number%5 == 0
    puts "Buzz"
  else
    puts number
  end
end
