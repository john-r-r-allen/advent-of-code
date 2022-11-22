require "csv"

module AdventOfCode
  class DayThree
    attr_reader :puzzle_input_path
    attr_accessor :gamma_rate_binary, :epsilon_rate_binary, :bit_one_values, :bit_zero_values

    def initialize(puzzle_input_path)
      @puzzle_input_path = puzzle_input_path
      @gamma_rate_binary = ""
      @epsilon_rate_binary = ""
      @bit_one_values = {}
      @bit_zero_values = {}
    end

    def puzzle_input
      @puzzle_input ||=  CSV.read(puzzle_input_path).map(&:first)
    end

    def part_one
      positions_in_string.times do |i|
        bit_one_values[i + 1] = 0
        bit_zero_values[i + 1] = 0
        puzzle_input.each do |input|
          bit_one_values[i + 1] += 1 if input[i] == "1"
          bit_zero_values[i + 1] += 1 if input[i] == "0"
        end

        @gamma_rate_binary += new_gamma_rate_binary_value(i + 1)
        @epsilon_rate_binary += new_epsilon_rate_binary_value(i + 1)
      end

      gamma_rate_binary.to_i(2) * epsilon_rate_binary.to_i(2)
    end

    def positions_in_string
      puzzle_input.first.size
    end

    def new_gamma_rate_binary_value(index)
      return "1" if more_bit_one_values_than_bit_zero_values?(index)

      "0"
    end

    def new_epsilon_rate_binary_value(index)
      return "0" if more_bit_one_values_than_bit_zero_values?(index)

      "1"
    end

    def more_bit_one_values_than_bit_zero_values?(index)
      bit_one_values[index] > bit_zero_values[index]
    end

    def add_to_gamma_rate_binary

    end

    # ============================================================================

    def part_two_array_bit_looping(puzzle_input, value_for_more_bit_one = "1", value_for_less_bit_one = "0") # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      new_puzzle_input = puzzle_input
      bit_one_values = {}
      bit_zero_values = {}
      output_binary = ""
      positions_in_string = puzzle_input.first.size - 1
      (0..positions_in_string).each do |n|
        bit_one_values[n + 1] = 0
        bit_zero_values[n + 1] = 0
        new_puzzle_input.each do |input|
          bit_one_values[n + 1] += 1 if input[n] == "1"
          bit_zero_values[n + 1] += 1 if input[n] == "0"
        end

        output_binary +=
          if bit_one_values[n + 1] >= bit_zero_values[n + 1]
            value_for_more_bit_one
          else
            value_for_less_bit_one
          end

        temp = new_puzzle_input.find_all { |input| input[0..n] == output_binary }
        new_puzzle_input = temp
        output_binary = temp.first if temp.size == 1
        break if temp.size == 1
      end

      output_binary
    end

    def part_two
      oxygen_generator_rate = part_two_array_bit_looping(puzzle_input).to_i(2)
      co2_scrubber_rating = part_two_array_bit_looping(puzzle_input, "0", "1").to_i(2)

      oxygen_generator_rate * co2_scrubber_rating
    end
  end
end
