require 'csv'
require 'pry'

SAMPLE_INPUT_FILE = '../../inputs/sample_inputs/day_9.csv'.freeze
INPUT_FILE = '../../inputs/day_9.csv'.freeze

def input_file_to_hash(input_file)
  output = {}
  CSV.read(input_file).each_with_index do |values, index|
    output[index] = []
    (1..values.first.size).each do |n|
      output[index] << values.first[n - 1].to_i
    end
  end
  output
end

def sum_of_risk_level(low_points)
  sum = 0

  low_points.each { |point| sum += (point + 1) }

  sum
end

def find_low_points(puzzle_input) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
  low_points = []
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
      up_point = (up_index >= min_column_index ? puzzle_input[up_index][row_index] : nil)
      down_point = (down_index <= max_column_index ? puzzle_input[down_index][row_index] : nil)
      left_point = (left_index >= min_row_index ? puzzle_input[column_index][left_index] : nil)
      right_point = (right_index <= max_row_index ? puzzle_input[column_index][right_index] : nil)
      low_points << row_info if row_info < [up_point, down_point, left_point, right_point].compact.min
    end
  end

  low_points
end

puzzle_input = input_file_to_hash(INPUT_FILE)

puts "Part 1: Sum of low point risk levels: #{sum_of_risk_level(find_low_points(puzzle_input))}"

# =====================================================================================================================
def input_file_to_hash_for_part_2(input_file)
  output = {}
  CSV.read(input_file).each_with_index do |values, index|
    output[index] = []
    (1..values.first.size).each do |n|
      output[index] << { value: values.first[n - 1].to_i, counted: false }
    end
  end
  output
end

def puzzle_input_2
  @puzzle_input_2 ||= input_file_to_hash_for_part_2(INPUT_FILE)
end

def add_to_basins(column_index, row_index)
  new_basin = []
  new_basin << { column: column_index, row: row_index }
  puzzle_input_2[column_index][row_index][:counted] = true

  add_other_points_to_new_basin(starting_point: new_basin.first, new_basin: new_basin)

  basins << new_basin
end

def basins
  @basins ||= []
end

def add_other_points_to_new_basin(starting_point:, new_basin:)
  col = starting_point[:column]
  row = starting_point[:row]
  up = {}
  down = {}
  left = {}
  right = {}

  up[:col] = col - 1
  down[:col] = col + 1
  left[:col] = col
  right[:col] = col
  up[:row] = row
  down[:row] = row
  left[:row] = row - 1
  right[:row] = row + 1
  up_point = puzzle_input_2&.dig(up[:col])&.dig(up[:row]) if up[:col] >= 0 && up[:row] >= 0
  down_point = puzzle_input_2&.dig(down[:col])&.dig(down[:row]) if down[:col] >= 0 && down[:row] >= 0
  left_point = puzzle_input_2&.dig(left[:col])&.dig(left[:row]) if left[:col] >= 0 && left[:row] >= 0
  right_point = puzzle_input_2&.dig(right[:col])&.dig(right[:row]) if right[:col] >= 0 && right[:row] >= 0

  if !up_point.nil? && up_point[:counted] == false && up_point[:value] != 9
    new_basin << { column: up[:col], row: up[:row] }
    up_point[:counted] = true
    add_other_points_to_new_basin(starting_point: { column: up[:col], row: up[:row] }, new_basin: new_basin)
  end

  if !down_point.nil? && down_point[:counted] == false && down_point[:value] != 9
    new_basin << { column: down[:col], row: down[:row] }
    down_point[:counted] = true
    add_other_points_to_new_basin(starting_point: { column: down[:col], row: down[:row] }, new_basin: new_basin)
  end

  if !left_point.nil? && left_point[:counted] == false && left_point[:value] != 9
    new_basin << { column: left[:col], row: left[:row] }
    left_point[:counted] = true
    add_other_points_to_new_basin(starting_point: { column: left[:col], row: left[:row] }, new_basin: new_basin)
  end

  if !right_point.nil? && right_point[:counted] == false && right_point[:value] != 9
    new_basin << { column: right[:col], row: right[:row] }
    right_point[:counted] = true
    add_other_points_to_new_basin(starting_point: { column: right[:col], row: right[:row] }, new_basin: new_basin)
  end
end

puzzle_input_2.each do |column_index, column_info|
  column_info.each_with_index do |row_info, row_index|
    add_to_basins(column_index, row_index) if row_info[:value] != 9 && row_info[:counted] == false
    row_info[:counted] = true
  end
end

largest_basin_1 = nil
largest_basin_2 = nil
largest_basin_3 = nil

basin_sizes = basins.map { |basin| basin.size }.sort

puts "Part 2: Product of largest three basins: #{basin_sizes[-1] * basin_sizes[-2] * basin_sizes[-3]}"