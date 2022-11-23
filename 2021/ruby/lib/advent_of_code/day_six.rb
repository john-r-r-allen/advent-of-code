require 'csv'

module AdventOfCode
  class DaySix
    attr_reader :original_puzzle_input

    def initialize(puzzle_input_path)
      @original_puzzle_input = CSV.read(puzzle_input_path).first.map(&:to_i)
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

    def part_one
      puzzle_input = original_puzzle_input.dup
      (1..80).each do |_day|
        puzzle_input = process_day(puzzle_input)
      end

      puzzle_input.size
    end

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

    def part_two
      input_hash = {}
      (0..8).each do |num|
        input_hash[num] = 0
      end

      puzzle_input = original_puzzle_input.dup
      puzzle_input.each do |num|
        input_hash[num] += 1
      end

      input_hash = process_days_using_hash(days: 256, input_hash: input_hash)
      input_hash[0] + input_hash[1] + input_hash[2] + input_hash[3] + input_hash[4] + input_hash[5] + input_hash[6] + input_hash[7] + input_hash[8]
    end
  end
end

