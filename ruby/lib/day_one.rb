require 'csv'

puzzle_input = CSV.read("../../inputs/input_day_1_2021.csv").map { |input| input.first.to_i }

number_of_increases = 0
prev_input = nil

puzzle_input.each do |input|
  number_of_increases += 1 if !prev_input.nil? && input > prev_input
  prev_input = input
end

puts "Part 1: #{number_of_increases}"

number_of_increases = 0
prev_input_one = nil
prev_input_two = nil
prev_input_three = nil

puzzle_input.each do |input|
  number_of_increases += 1 if !prev_input_three.nil? && !prev_input_two.nil? && !prev_input_one.nil? && (prev_input_two + prev_input_one + input) > (prev_input_three + prev_input_two + prev_input_one) # rubocop:disable Layout/LineLength
  prev_input_three = prev_input_two
  prev_input_two = prev_input_one
  prev_input_one = input
end

puts "Part 2: #{number_of_increases}"
