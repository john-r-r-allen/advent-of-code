module AdventOfCode
  class DayEighteen
    attr_reader :puzzle_input

    def initialize(puzzle_input_path)
      @puzzle_input = CSV.read(puzzle_input_path).map(&:first)
    end

    def part_one
      nil
    end

    def part_two
      nil
    end
  end
end
