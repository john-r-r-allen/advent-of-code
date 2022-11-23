require "csv"

module AdventOfCode
  class DayEight
    attr_reader :puzzle_input

    def initialize(puzzle_input_path)
      @puzzle_input = input_file_to_hash(puzzle_input_path)
    end

    def part_one
      count_recognizable_digits_in_puzzle
    end

    def part_two
      unique_digit_counts = {
        1 => 2,
        4 => 4,
        7 => 3,
        8 => 7
      }

      segments_to_signal_wires = {
        top_left: nil,
        top: nil,
        top_right: nil,
        middle: nil,
        bottom_left: nil,
        bottom: nil,
        bottom_right: nil
      }

      numbers_to_segments = {
        0 => {
          segments: %w(top_left top top_right bottom_left bottom bottom_right),
          unique_number_of_segments: false
        },
        1 => {
          segments: %w(top_right bottom_right),
          unique_number_of_segments: true
        },
        2 => {
          segments: %w(top top_right middle bottom_left bottom),
          unique_number_of_segments: false
        },
        3 => {
          segments: %w(top top_right middle bottom_right bottom),
          unique_number_of_segments: false
        },
        4 => {
          segments: %w(top_left top_right middle bottom_right),
          unique_number_of_segments: true
        },
        5 => {
          segments: %w(top_left top middle bottom bottom_right),
          unique_number_of_segments: false
        },
        6 => {
          segments: %w(top_left top middle bottom_left bottom bottom_right),
          unique_number_of_segments: false
        },
        7 => {
          segments: %w(top top_right bottom_right),
          unique_number_of_segments: true
        },
        8 => {
          segments: %w(top_left top top_right middle bottom_left bottom bottom_right),
          unique_number_of_segments: true
        },
        9 => {
          segments: %w(top_left top top_right middle bottom bottom_right),
          unique_number_of_segments: false
        }
      }

      numbers_to_segments.each do |number, _info|
        numbers_to_segments[number][:segment_size] = numbers_to_segments[number][:segments].size
      end

      output_values = []
      puzzle_input.each do |_puzzle_key, individual_puzzle|
        segments_to_signal_wires = {
          top_left: nil,
          top: nil,
          top_right: nil,
          middle: nil,
          bottom_left: nil,
          bottom: nil,
          bottom_right: nil
        }

        unmatched_segments = {}
        counts_per_size = {
          2 => 0,
          3 => 0,
          4 => 0,
          5 => 0,
          6 => 0,
          7 => 0
        }
        individual_puzzle.each do |key, value|
          break if key >= 10

          unmatched_segments[value.size] = {} unless unmatched_segments.key?(value.size)
          potential_matches = numbers_to_segments.select { |_number, info| info[:segment_size] == value.size }
          if potential_matches.size > 1
            unmatched_segments[value.size][counts_per_size[value.size]] = []
            value.size.times do |n|
              unmatched_segments[value.size][counts_per_size[value.size]] << value[n]
            end
            counts_per_size[value.size] += 1

            next
          end

          numbers_to_segments[potential_matches.keys.first][:segment_wires] = []
          value.size.times do |n|
            numbers_to_segments[potential_matches.keys.first][:segment_wires] << value[n]
          end
        end

        segments_to_signal_wires[:top] = numbers_to_segments[7][:segment_wires] - numbers_to_segments[1][:segment_wires]
        unmatched_segments[6].each do |key, value|
          remaining_segments = value - segments_to_signal_wires[:top] - numbers_to_segments[7][:segment_wires] - numbers_to_segments[4][:segment_wires]
          next unless remaining_segments.size == 1

          segments_to_signal_wires[:bottom] = remaining_segments
          numbers_to_segments[9][:segment_wires] = value
          unmatched_segments[6].delete(key)
          break
        end

        unmatched_segments[6].each do |_key, value|
          remaining_segments = numbers_to_segments[8][:segment_wires] - value - numbers_to_segments[1][:segment_wires]
          number = remaining_segments.size == 1 ? 0 : 6
          numbers_to_segments[number][:segment_wires] = value
        end
        segments_to_signal_wires[:bottom_left] = numbers_to_segments[8][:segment_wires] - numbers_to_segments[9][:segment_wires]
        segments_to_signal_wires[:top_right] = numbers_to_segments[8][:segment_wires] - numbers_to_segments[6][:segment_wires]
        segments_to_signal_wires[:middle] = numbers_to_segments[8][:segment_wires] - numbers_to_segments[0][:segment_wires]
        segments_to_signal_wires[:bottom_right] = numbers_to_segments[1][:segment_wires] - segments_to_signal_wires[:top_right]
        segments_to_signal_wires[:top_left] = numbers_to_segments[0][:segment_wires] - numbers_to_segments[7][:segment_wires] - segments_to_signal_wires[:bottom_left] - segments_to_signal_wires[:bottom]
        unmatched_segments[5].each do |_key, value|
          if (value - segments_to_signal_wires[:top] - segments_to_signal_wires[:top_right] - segments_to_signal_wires[:middle] - segments_to_signal_wires[:bottom_left] - segments_to_signal_wires[:bottom]).size.zero?
            numbers_to_segments[2][:segment_wires] = value
            next
          end
          if (value - numbers_to_segments[7][:segment_wires] - segments_to_signal_wires[:middle] - segments_to_signal_wires[:bottom]).size.zero?
            numbers_to_segments[3][:segment_wires] = value
            next
          end
          numbers_to_segments[5][:segment_wires] = value
        end
        # pretty_print_numbers_to_segments(numbers_to_segments)

        number_1_array = (1..individual_puzzle[11].size).map { |n| individual_puzzle[11][n - 1] }
        number_2_array = (1..individual_puzzle[12].size).map { |n| individual_puzzle[12][n - 1] }
        number_3_array = (1..individual_puzzle[13].size).map { |n| individual_puzzle[13][n - 1] }
        number_4_array = (1..individual_puzzle[14].size).map { |n| individual_puzzle[14][n - 1] }
        number_1 = determine_number(array_to_decipher: number_1_array, numbers_to_segments: numbers_to_segments)
        number_2 = determine_number(array_to_decipher: number_2_array, numbers_to_segments: numbers_to_segments)
        number_3 = determine_number(array_to_decipher: number_3_array, numbers_to_segments: numbers_to_segments)
        number_4 = determine_number(array_to_decipher: number_4_array, numbers_to_segments: numbers_to_segments)
        output_values << (number_1 + number_2 + number_3 + number_4).to_i
      end

      output_values.sum
    end

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

    def count_recognizable_digits_in_puzzle
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

          count += 1 unless unique_digit_counts.key(hash_value.size).nil?
        end
      end

      count
    end

    def pretty_print_numbers_to_segments(numbers_to_segments)
      puts "numbers_to_segments: {"
      numbers_to_segments.each do |top_key, top_value|
        puts "\t#{top_key}: {"
        top_value.each do |key, value|
          puts "\t\t#{key}: #{value}"
        end
        puts "\t}"
      end
      puts "}"
    end

    def determine_number(array_to_decipher:, numbers_to_segments:)
      numbers_to_segments.each do |number, number_info|
        return number.to_s if number_info[:segment_wires].sort == array_to_decipher.sort
      end
    end
  end
end
