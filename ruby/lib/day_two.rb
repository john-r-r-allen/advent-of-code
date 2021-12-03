require 'csv'

puzzle_input = CSV.read('../../inputs/input_day_2_2021.csv').map { |input| input.first }

horizontal_position = 0
depth = 0

puzzle_input.each do |input|
  movement = input[input.size - 1].to_i
  depth += movement if input[0] == 'd'
  depth -= movement if input[0] == 'u'
  horizontal_position += movement if input[0] == 'f'
end

puts "Part 1: #{depth * horizontal_position}"

horizontal_position = 0
depth = 0
aim = 0

puzzle_input.each do |input|
  movement = input[input.size - 1].to_i
  aim += movement if input[0] == 'd'
  aim -= movement if input[0] == 'u'
  if input[0] == 'f'
    horizontal_position += movement
    depth += (aim * movement)
  end
end

puts "Part 2: #{depth * horizontal_position}"
