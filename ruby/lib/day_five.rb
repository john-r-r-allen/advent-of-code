require 'csv'
require 'pry'

SAMPLE_INPUT_FILE = '../../inputs/sample_inputs/day_5.csv'.freeze
INPUT_FILE = '../../inputs/input_day_5_2021.csv'.freeze

def file_to_array(input_file)
  temp = []
  output = []

  CSV.read(input_file).each do |value_array|
    temp << value_array.map { |value| value.gsub(' -> ', ',').split(',') }.flatten
  end

  temp.each_with_index do |value, index|
    output[index] = {}
    output[index][:x1] = value[0].to_i
    output[index][:y1] = value[1].to_i
    output[index][:x2] = value[2].to_i
    output[index][:y2] = value[3].to_i
  end

  output
end

def produce_diagram(min_x:, min_y:, max_x:, max_y:)
  temp = {}

  (min_x..max_x).each do |x|
    temp[x] = {}
    (min_y..max_y).each do |y|
      temp[x][y] = 0
    end
  end

  temp
end

def mark_lines_on_diagram_for_part_1(diagram:, coordinates:)
  x1 = coordinates[:x1]
  x2 = coordinates[:x2]
  y1 = coordinates[:y1]
  y2 = coordinates[:y2]

  return if x1 != x2 && y1 != y2

  if x1 == x2
    y_values = [y1, y2]
    (y_values.min..y_values.max).each do |y|
      diagram[x1][y] += 1
    end
  end

  return unless y1 == y2

  x_values = [x1, x2]
  (x_values.min..x_values.max).each do |x|
    diagram[x][y1] += 1
  end
end

def mark_lines_on_diagram_for_part_2(diagram:, coordinates:)
  x1 = coordinates[:x1]
  x2 = coordinates[:x2]
  y1 = coordinates[:y1]
  y2 = coordinates[:y2]

  if x1 == x2
    y_values = [y1, y2]
    (y_values.min..y_values.max).each do |y|
      diagram[x1][y] += 1
    end
  end

  if y1 == y2
    x_values = [x1, x2]
    (x_values.min..x_values.max).each do |x|
      diagram[x][y1] += 1
    end
  end

  return unless x1 != x2 && y1 != y2

  slope = (y2 - y1) / (x2 - x1)

  # puts "(x1,y1): (#{x1}, #{y1}) - (x2,y2): (#{x2}, #{y2}) - slope: #{slope}"

  if x1 < x2
    (x1..x2).each do |x|
      calculated_y = y1 + ((x - x1) * slope)
      # puts "x1..x2, current x value: #{x}, incrementing value in diagram[#{x}][#{calculated_y}]"
      diagram[x][calculated_y] += 1
    end
  else
    (x2..x1).each do |x|
      calculated_y = y2 + ((x - x2) * slope)
      # puts "x2..x1, current x value: #{x}, incrementing value in diagram[#{x}][#{calculated_y}]"
      diagram[x][calculated_y] += 1
    end
  end
end

def find_number_of_multiple_hit_locations(diagram:)
  counter = 0

  diagram.each do |row_index, row|
    row.each do |column_index, _column|
      counter += 1 if diagram[row_index][column_index] > 1
    end
  end

  counter
end

# ====================================================================================
# Part 1
# ====================================================================================

puzzle_input = file_to_array(INPUT_FILE)

min_x_value = nil
min_y_value = nil
max_x_value = 0
max_y_value = 0

puzzle_input.each do |hash|
  min_x_value = hash[:x1] if min_x_value.nil?
  min_y_value = hash[:y1] if min_y_value.nil?

  min_x_value = hash[:x1] if hash[:x1] < min_x_value
  min_x_value = hash[:x2] if hash[:x2] < min_x_value
  min_y_value = hash[:y1] if hash[:y1] < min_y_value
  min_y_value = hash[:y2] if hash[:y2] < min_y_value

  max_x_value = hash[:x1] if hash[:x1] > max_x_value
  max_x_value = hash[:x2] if hash[:x2] > max_x_value
  max_y_value = hash[:y1] if hash[:y1] > max_y_value
  max_y_value = hash[:y2] if hash[:y2] > max_y_value
end

diagram = produce_diagram(min_x: min_x_value, min_y: min_y_value, max_x: max_x_value, max_y: max_y_value)
puzzle_input.each do |coordinates|
  mark_lines_on_diagram_for_part_1(diagram: diagram, coordinates: coordinates)
end

puts "Part 1 answer: #{find_number_of_multiple_hit_locations(diagram: diagram)}"

# ====================================================================================
# Part 2
# ====================================================================================

puzzle_input = file_to_array(INPUT_FILE)

min_x_value = nil
min_y_value = nil
max_x_value = 0
max_y_value = 0

puzzle_input.each do |hash|
  min_x_value = hash[:x1] if min_x_value.nil?
  min_y_value = hash[:y1] if min_y_value.nil?

  min_x_value = hash[:x1] if hash[:x1] < min_x_value
  min_x_value = hash[:x2] if hash[:x2] < min_x_value
  min_y_value = hash[:y1] if hash[:y1] < min_y_value
  min_y_value = hash[:y2] if hash[:y2] < min_y_value

  max_x_value = hash[:x1] if hash[:x1] > max_x_value
  max_x_value = hash[:x2] if hash[:x2] > max_x_value
  max_y_value = hash[:y1] if hash[:y1] > max_y_value
  max_y_value = hash[:y2] if hash[:y2] > max_y_value
end

diagram = produce_diagram(min_x: min_x_value, min_y: min_y_value, max_x: max_x_value, max_y: max_y_value)
puzzle_input.each do |coordinates|
  mark_lines_on_diagram_for_part_2(diagram: diagram, coordinates: coordinates)
end

puts "Part 2 answer: #{find_number_of_multiple_hit_locations(diagram: diagram)}"
