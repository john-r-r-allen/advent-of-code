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

    def bits_in_diagnostic_report(bit_value)
      bit_counter = []

      characters_on_diagnostic_report_line.times do |position|
        bit_counter << bits_on_report_line(bit_value:, position:, report: diagnostic_report) # rubocop:disable Layout/SpaceAfterColon
      end

      bit_counter
    end

    def bits_on_report_line(bit_value:, position:, report:)
      report.count { |report_line| report_line[position] == bit_value }
    end

    def part_two_array_bit_looping(value_for_more_bit_ones, value_for_less_bit_ones) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      modified_diagnostic_report = diagnostic_report.dup
      part_two_bit_one_values = []
      part_two_bit_zero_values = []
      output_binary = ""
      characters_on_diagnostic_report_line.times do |i|
        part_two_bit_one_values << bits_on_report_line(bit_value: "1", position: i, report: modified_diagnostic_report)
        part_two_bit_zero_values << bits_on_report_line(bit_value: "0", position: i, report: modified_diagnostic_report)

        output_binary +=
          if part_two_bit_one_values[i] >= part_two_bit_zero_values[i]
            value_for_more_bit_ones
          else
            value_for_less_bit_ones
          end

        modified_diagnostic_report.select! { |input| input[0..i] == output_binary }
        output_binary = modified_diagnostic_report.first if modified_diagnostic_report.size == 1
        break if modified_diagnostic_report.size == 1
      end

      output_binary
    end

    def part_two
      life_support_rating
    end

    def life_support_rating
      oxygen_generator_rating * co2_scrubber_rating
    end

    def oxygen_generator_rating
      part_two_array_bit_looping("1", "0").to_i(2)
    end

    def co2_scrubber_rating
      part_two_array_bit_looping("0", "1").to_i(2)
    end
  end
end
