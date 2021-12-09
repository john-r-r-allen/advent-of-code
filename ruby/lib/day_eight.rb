require 'csv'
require 'pry'

SAMPLE_INPUT_FILE = '../../inputs/sample_inputs/day_8.csv'.freeze
INPUT_FILE = '../../inputs/day_8.csv'.freeze

def input_file_to_hash(input_file)
  output = {}
  temp = CSV.read(input_file).each.map{ |input| input.first.split(' ') }
  temp.each_with_index.map do |array_value, outer_index|
    output[outer_index] = {}
    array_value.each_with_index.map do |value, inner_index|
      output[outer_index][inner_index] = value
    end
  end
  output
end

def count_recognizable_digits_in_puzzle(puzzle_input:, debugging: false)
  count = 0
  unique_digit_counts = {
    1 => 2,
    4 => 4,
    7 => 3,
    8 => 7
  }
  puzzle_input.each do |_input_number, hash|
    hash.each do |hash_key, hash_value|
      next if hash_key <= 10
      puts "Count is #{count} before processing hash_value #{hash_value} with a size of #{hash_value.size}" if debugging
      count += 1 if !unique_digit_counts.key(hash_value.size).nil?
      puts "Count after processing is #{count}" if debugging
    end
  end

  count
end

puzzle_input = input_file_to_hash(INPUT_FILE)
puts "Part 1: Count of recognizable digits (1, 4, 7, and 8): #{count_recognizable_digits_in_puzzle(puzzle_input: puzzle_input)}" # rubocop:disable Layout/LineLength
