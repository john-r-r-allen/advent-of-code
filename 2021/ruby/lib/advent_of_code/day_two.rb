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
      puzzle_input.each do |input|
        movement = input[input.size - 1].to_i
        submarine_part_one.move(input, movement)
      end

      submarine_part_one.horizontal_position_and_depth_product
    end

    def submarine_part_one
      @submarine_part_one ||= SubmarinePositioningPartOne.new(initial_horizontal_position: 0, initial_depth: 0)
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

    class SubmarinePositioningPartOne
      attr_reader :horizontal_position, :depth

      def initialize(initial_horizontal_position:, initial_depth:)
        @horizontal_position = initial_horizontal_position
        @depth = initial_depth
      end

      def move(direction, movement)
        @horizontal_position += horizontal_increase(direction, movement)
        @depth += depth_increase(direction, movement)

        self
      end

      def depth_increase(direction, movement)
        return movement if direction.start_with?("down")
        return movement * -1 if direction.start_with?("up")

        0
      end

      def horizontal_increase(direction, movement)
        return movement if direction.start_with?("forward")

        0
      end

      def horizontal_position_and_depth_product
        horizontal_position * depth
      end
    end
  end
end
