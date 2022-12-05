module AdventOfCode
  class DayFour
    attr_reader :camp_cleanup_assignments

    def initialize(puzzle_input_path)
      @camp_cleanup_assignments = CSV.read(puzzle_input_path)
    end

    def part_one
      complete_overlaps = 0
      camp_cleanup_assignments.each do |cleanup_assignment_pair|
        first_range = convert_cleanup_assignment_to_range(cleanup_assignment_pair.first)
        second_range = convert_cleanup_assignment_to_range(cleanup_assignment_pair.last)

        next unless first_range.overlaps?(second_range)

        complete_overlaps += 1 if one_range_fully_contains_other_range?(first_range, second_range)\
      end
      complete_overlaps
    end

    def one_range_fully_contains_other_range?(first_range, second_range)
      (first_range.first <= second_range.first && first_range.last >= second_range.last) ||
        (second_range.first <= first_range.first && second_range.last >= first_range.last)
    end

    def convert_cleanup_assignment_to_range(range_string)
      dash_location = range_string.index("-")
      Range.new(range_string[0..(dash_location - 1)].to_i, range_string[(dash_location + 1)..].to_i)
    end

    def part_two
      overlaps = 0
      camp_cleanup_assignments.each do |cleanup_assignment_pair|
        first_range = convert_cleanup_assignment_to_range(cleanup_assignment_pair.first)
        second_range = convert_cleanup_assignment_to_range(cleanup_assignment_pair.last)

        overlaps += 1 if first_range.overlaps?(second_range)
      end
      overlaps
    end
  end
end
