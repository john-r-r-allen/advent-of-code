module AdventOfCode
  class DaySix
    attr_reader :puzzle_input

    def initialize(puzzle_input_path)
      @puzzle_input = CSV.read(puzzle_input_path).map(&:first).first
    end

    def part_one
      start_of_packet_marker_location
    end

    def start_of_packet_marker_location
      puzzle_input.size.times do |i|
        next unless i >= 3

        last_four_start = i - 3
        return i + 1 if all_unique_characters(puzzle_input[last_four_start..i])
      end
    end

    def all_unique_characters(string)
      characters = string.split("")
      characters.each_with_index do |character, index|
        return true if index == characters.size
        return false if characters[(index + 1)..].include?(character)
      end

      true
    end

    def part_two
      start_of_message_marker_location
    end

    def start_of_message_marker_location
      puzzle_input.size.times do |i|
        next unless i >= 13

        last_fourteen_start = i - 13
        return i + 1 if all_unique_characters(puzzle_input[last_fourteen_start..i])
      end
    end
  end
end
