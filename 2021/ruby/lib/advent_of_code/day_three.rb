require "csv"

module AdventOfCode
  class DayThree
    attr_reader :diagnostic_report_path

    def initialize(diagnostic_report_path)
      @diagnostic_report_path = diagnostic_report_path
    end

    def diagnostic_report
      @diagnostic_report ||= CSV.read(diagnostic_report_path).map(&:first)
    end

    def part_one
      gamma_rate_binary.to_i(2) * epsilon_rate_binary.to_i(2)
    end

    def gamma_rate_binary
      return @gamma_rate_binary if defined?(@gamma_rate_binary)

      @gamma_rate_binary = ""
      characters_on_diagnostic_report_line.times do |position|
        @gamma_rate_binary += new_gamma_rate_binary_value(position)
      end

      @gamma_rate_binary
    end

    def epsilon_rate_binary
      return @epsilon_rate_binary if defined?(@epsilon_rate_binary)

      @epsilon_rate_binary = ""
      characters_on_diagnostic_report_line.times do |position|
        @epsilon_rate_binary += new_epsilon_rate_binary_value(position)
      end

      @epsilon_rate_binary
    end

    def bits_in_diagnostic_report(bit_value)
      bit_counter = []

      characters_on_diagnostic_report_line.times do |position|
        bit_counter << diagnostic_report.count { |report_line| report_line[position] == bit_value }
      end

      bit_counter
    end

    def characters_on_diagnostic_report_line
      diagnostic_report.first.size
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

    def bit_one_values
      @bit_one_values ||= bits_in_diagnostic_report("1")
    end

    def bit_zero_values
      @bit_zero_values ||= bits_in_diagnostic_report("0")
    end

    def part_two_array_bit_looping(value_for_more_bit_one = "1", value_for_less_bit_one = "0") # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      new_puzzle_input = diagnostic_report
      bit_one_values = {}
      bit_zero_values = {}
      output_binary = ""
      positions_in_string = diagnostic_report.first.size - 1
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

        temp = new_puzzle_input.select { |input| input[0..n] == output_binary }
        new_puzzle_input = temp
        output_binary = temp.first if temp.size == 1
        break if temp.size == 1
      end

      output_binary
    end

    def part_two
      oxygen_generator_rate = part_two_array_bit_looping.to_i(2)
      co2_scrubber_rating = part_two_array_bit_looping("0", "1").to_i(2)

      oxygen_generator_rate * co2_scrubber_rating
    end
  end
end
