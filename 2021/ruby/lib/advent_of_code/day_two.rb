require 'csv'

module AdventOfCode
  class DayTwo
    attr_reader :puzzle_input_path

    def initialize(puzzle_input_path)
      @puzzle_input_path = puzzle_input_path
    end

    def puzzle_input
      @puzzle_input ||= CSV.read(puzzle_input_path).map(&:first)
    end

    def part_one
      horizontal_position = 0
      depth = 0

      puzzle_input.each do |input|
        movement = input[input.size - 1].to_i
        depth += movement if input[0] == 'd'
        depth -= movement if input[0] == 'u'
        horizontal_position += movement if input[0] == 'f'
      end

      depth * horizontal_position
    end

    def part_two
      horizontal_position = 0
      depth = 0
      aim = 0

      puzzle_input.each do |input|
        movement = input[input.size - 1].to_i
        aim += movement if input[0] == 'd'
        aim -= movement if input[0] == 'u'
        if input[0] == 'f'
          horizontal_position += movement
          depth += (aim * movement)
        end
      end

      depth * horizontal_position
    end
  end
end
