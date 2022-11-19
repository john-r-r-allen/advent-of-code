require "csv"

module AdventOfCode
  class DayOne
    attr_reader :input_file

    def initialize(puzzle_input_file)
      @input_file = puzzle_input_file
    end

    def sonar_sweep_depth
      @sonar_sweep_depth ||= CSV.read(input_file).map { |input| input.first.to_i }
    end

    def part_one
      number_of_increases = 0

      sonar_sweep_depth.size.times do |position_number|
        next if position_number.zero?

        number_of_increases += 1 if depth_increase?(position_number)
      end

      number_of_increases
    end

    def depth_increase?(position_number)
      sonar_sweep_depth[position_number] > sonar_sweep_depth[position_number - 1]
    end

    def part_two
      number_of_increases = 0

      sonar_sweep_depth.size.times do |position_number|
        next if position_number <= 2

        number_of_increases += 1 if sliding_window_depth_increase?(position_number)
      end

      number_of_increases
    end

    def sliding_window_depth_increase?(position_number)
      current_sliding_window(position_number).sum > previous_sliding_window(position_number).sum
    end

    def current_sliding_window(position_number)
      sonar_sweep_depth[position_number - 2..position_number]
    end

    def previous_sliding_window(position_number)
      sonar_sweep_depth[position_number - 3..position_number - 1]
    end
  end
end
