require 'csv'
require 'pry'

SAMPLE_INPUT_FILE = '../../inputs/sample_inputs/day_six.csv'.freeze
INPUT_FILE = '../../inputs/day_six.csv'.freeze

def input_file_to_array(input_file)
  CSV.read(input_file).first.map(&:to_i)
end

def process_day(puzzle_input)
  fish_to_add = 0
  temp =
    puzzle_input.map do |fish|
      if fish.zero?
        fish_to_add += 1
        fish = 6
      else
        fish -= 1
      end
    end

  (1..fish_to_add).each { |_number| temp << 8 }

  temp
end

puzzle_input = input_file_to_array(INPUT_FILE)
# puts "Before processing day: #{puzzle_input}"
(1..80).each do |_day|
  puzzle_input = process_day(puzzle_input)
end
# puts "After processing day: #{puzzle_input}"

puts "Part 1: Total Lantern Fish: #{puzzle_input.size}"

def process_days_using_hash(days:, input_hash:)
  temp_hash = input_hash
  (1..days).each do |_day|
    count_in_7 = temp_hash[8] # rubocop:disable Naming/VariableNumber
    count_in_6 = temp_hash[7] # rubocop:disable Naming/VariableNumber
    count_in_5 = temp_hash[6] # rubocop:disable Naming/VariableNumber
    count_in_4 = temp_hash[5] # rubocop:disable Naming/VariableNumber
    count_in_3 = temp_hash[4] # rubocop:disable Naming/VariableNumber
    count_in_2 = temp_hash[3] # rubocop:disable Naming/VariableNumber
    count_in_1 = temp_hash[2] # rubocop:disable Naming/VariableNumber
    count_in_0 = temp_hash[1] # rubocop:disable Naming/VariableNumber
    count_in_6 += temp_hash[0] # rubocop:disable Naming/VariableNumber
    count_in_8 = temp_hash[0] # rubocop:disable Naming/VariableNumber

    temp_hash = {
      8 => count_in_8,
      7 => count_in_7,
      6 => count_in_6,
      5 => count_in_5,
      4 => count_in_4,
      3 => count_in_3,
      2 => count_in_2,
      1 => count_in_1,
      0 => count_in_0
    }
  end

  temp_hash
end

input_hash = {}
(0..8).each do |num|
  input_hash[num] = 0
end

puzzle_input = input_file_to_array(INPUT_FILE)
puzzle_input.each do |num|
  input_hash[num] += 1
end

puts "#{DateTime.now} start process_days_using_hash 150 days input [1]"
input_hash = process_days_using_hash(days: 256, input_hash: input_hash)
puts "#{DateTime.now} end process_days_using_hash 150 days input [1]"
puts "input_hash total: #{input_hash[0] + input_hash[1] + input_hash[2] + input_hash[3] + input_hash[4] + input_hash[5] + input_hash[6] + input_hash[7] + input_hash[8]}" # rubocop:disable Layout/LineLength
