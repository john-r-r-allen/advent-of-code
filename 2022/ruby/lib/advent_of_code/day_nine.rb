module AdventOfCode
  class DayNine
    RIGHT = "R".freeze
    LEFT = "L".freeze
    UP = "U".freeze
    DOWN = "D".freeze
    DISTANCE_BETWEEN_KNOTS = 1
    START_COORDINATES = { x: 0, y: 0 }.freeze
    LAST_KNOT_PART_TWO = 9

    attr_reader :puzzle_input, :knot_zero_coordinates, :knot_one_coordinates, :tail_positions, :knots

    def initialize(puzzle_input_path)
      @puzzle_input = CSV.read(puzzle_input_path).map(&:first).map do |input|
        number_of_moves = input.split.last.to_i
        Array.new(number_of_moves) { input.split.first }
      end.flatten
      @knot_zero_coordinates = START_COORDINATES.dup
      @knot_one_coordinates = START_COORDINATES.dup
      @tail_positions = [START_COORDINATES.dup]
      @knots = {
        0 => START_COORDINATES.dup,
        1 => START_COORDINATES.dup,
        2 => START_COORDINATES.dup,
        3 => START_COORDINATES.dup,
        4 => START_COORDINATES.dup,
        5 => START_COORDINATES.dup,
        6 => START_COORDINATES.dup,
        7 => START_COORDINATES.dup,
        8 => START_COORDINATES.dup,
        9 => START_COORDINATES.dup,
      }
    end

    def part_one
      puzzle_input.each do |direction|
        move_head(direction:, head_knot: knot_zero_coordinates)
        next unless needs_to_move?(knot: knot_one_coordinates, leading_knot: knot_zero_coordinates)

        move_knot(knot: knot_one_coordinates, leading_knot: knot_zero_coordinates)
        tail_positions << knot_one_coordinates.dup
      end
      tail_positions.uniq.count
    end

    def move_head(direction:, head_knot:)
      case direction
      when RIGHT
        head_knot[:x] += 1
      when LEFT
        head_knot[:x] -= 1
      when UP
        head_knot[:y] += 1
      when DOWN
        head_knot[:y] -= 1
      else
        raise "Unknown direction provided. Direction: #{direction}"
      end
    end

    def needs_to_move?(knot:, leading_knot:)
      return true if (leading_knot[:x] - knot[:x]).abs > DISTANCE_BETWEEN_KNOTS
      return true if (leading_knot[:y] - knot[:y]).abs > DISTANCE_BETWEEN_KNOTS

      false
    end

    def move_knot(knot:, leading_knot:)
      knot[:x] += 1 if leading_knot[:x] > (knot[:x])
      knot[:x] -= 1 if leading_knot[:x] < (knot[:x])
      knot[:y] += 1 if leading_knot[:y] > (knot[:y])
      knot[:y] -= 1 if leading_knot[:y] < (knot[:y])
    end

    def part_two
      puzzle_input.each do |direction|
        knots.each do |knot_number, knot|
          if knot_number.zero?
            move_head(direction:, head_knot: knot)
            next
          end

          break unless needs_to_move?(knot: knot, leading_knot: knots[knot_number - 1])

          move_knot(knot: knot_one_coordinates, leading_knot: knots[knot_number - 1])
          tail_positions << knot_one_coordinates.dup if knot_number == LAST_KNOT_PART_TWO
        end
      end
      tail_positions.uniq.count
    end
  end
end
