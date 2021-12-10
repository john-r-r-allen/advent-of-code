require 'csv'
require 'pry'

SAMPLE_INPUT_FILE = '../../inputs/sample_inputs/day_9.csv'.freeze
INPUT_FILE = '../../inputs/day_9.csv'.freeze

def input_file_to_hash(input_file)
  output = {}
  CSV.read(input_file).each_with_index do |values, index|
    output[index] = []
    (1..values.first.size).each do |n|
      output[index] << values.first[n - 1]
    end
  end
  output
end

def sum_of_risk_level(low_points)
  sum = 0

  low_points.each { |point| sum += (point + 1) }

  sum
end

def find_low_points(puzzle_input)
  low_points = []
  current_row_index = 0
  max_row_index = puzzle_input[0].size - 1
  min_row_index = 0
  min_column_index = 0
  max_column_index = puzzle_input.size - 1
  puzzle_input.each do |column_index, column_info|
    column_info.each_with_index do |row_info, row_index|
      up_index = column_index - 1
      down_index = column_index + 1
      left_index = row_index - 1
      right_index = row_index + 1
      up_point = (up_index >= min_column_index ? puzzle_input[up_index][row_index].to_i : nil)
      down_point = (down_index <= max_column_index ? puzzle_input[down_index][row_index].to_i : nil)
      left_point = (left_index >= min_row_index ? puzzle_input[column_index][left_index].to_i : nil)
      right_point = (right_index <= max_row_index ? puzzle_input[column_index][right_index].to_i : nil)
      low_points << row_info.to_i if row_info.to_i < [up_point, down_point, left_point, right_point].compact.min
    end
  end

  low_points
end

puzzle_input = input_file_to_hash(INPUT_FILE)

puts "Part 1: Sum of low point risk levels: #{sum_of_risk_level(find_low_points(puzzle_input))}"
