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
        depth += depth_increase_part_one(input, movement)
        horizontal_position += horizontal_increase_part_one(input, movement)
      end

      depth * horizontal_position
    end

    def depth_increase_part_one(instruction, movement)
      return movement if instruction.start_with?("down")
      return movement * -1 if instruction.start_with?("up")

      0
    end

    def horizontal_increase_part_one(instruction, movement)
      return movement if instruction.start_with?("forward")

      0
    end

    def part_two # rubocop:disable Metrics/MethodLength
      horizontal_position = 0
      depth = 0
      aim = 0

      puzzle_input.each do |input|
        movement = input[input.size - 1].to_i
        aim += aim_increase(input, movement)
        if input.start_with?("forward")
          horizontal_position += movement
          depth += (aim * movement)
        end
      end

      depth * horizontal_position
    end

    def aim_increase(direction, movement)
      return movement if direction.start_with?("down")
      return movement * -1 if direction.start_with?("up")

      0
    end
  end
end
