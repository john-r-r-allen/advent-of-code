module AdventOfCode
  module Model
    class SubmarinePositioningPartOne
      attr_accessor :horizontal_position, :depth

      def initialize(initial_horizontal_position:, initial_depth:)
        @horizontal_position = initial_horizontal_position
        @depth = initial_depth
      end

      def move(direction, movement)
        depth += depth_increase(direction, movement)
        horizontal_position += horizontal_increase(direction, movement)

        self
      end

      def depth_increase(instruction, movement)
        return movement if instruction.start_with?("down")
        return movement * -1 if instruction.start_with?("up")

        0
      end

      def horizontal_increase(instruction, movement)
        return movement if instruction.start_with?("forward")

        0
      end

      def horizontal_position_and_depth_product
        horizontal_position * depth
      end
    end
  end
end
