# Runs in the terminal
# Prints a pyramid of given height

height = ARGV[0].to_i
output = ""
(1..height).each do |h|
  pad = height - h
  output << " " * pad
  output << "*" * (2*h)
  output << " " * pad
  output << "\n"
end
puts output
