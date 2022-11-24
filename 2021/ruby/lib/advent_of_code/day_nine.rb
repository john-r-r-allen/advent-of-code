module AdventOfCode
  class DayNine # rubocop:disable Metrics/ClassLength
    NOT_A_BASIN = 9

    attr_reader :original_puzzle_input_part_two, :cave_floor_heightmap

    def initialize(puzzle_input_path)
      @cave_floor_heightmap = input_file_to_hash(puzzle_input_path)
      @original_puzzle_input_part_two = input_file_to_hash_for_part_two(puzzle_input_path)
    end

    def input_file_to_hash(input_file)
      output = {}
      CSV.read(input_file).each_with_index do |values, index|
        output[index] = []
        (1..values.first.size).each do |n|
          output[index] << values.first[n - 1].to_i
        end
      end
      output
    end

    def sum_of_risk_level(low_points)
      sum = 0

      low_points.each { |point| sum += (point + 1) }

      sum
    end

    def find_low_points(puzzle_input) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
      low_points = []
      max_row_index = puzzle_input[0].size - 1
      min_row_index = 0
      min_column_index = 0
      max_column_index = puzzle_input.size - 1
      puzzle_input.each do |column_index, column_info|
        column_info.each_with_index do |row_info, row_index|
          up_index = column_index - 1
          down_index = column_index + 1
          left_index = row_index - 1
          right_index = row_index + 1
          up_point = (up_index >= min_column_index ? puzzle_input[up_index][row_index] : nil)
          down_point = (down_index <= max_column_index ? puzzle_input[down_index][row_index] : nil)
          left_point = (left_index >= min_row_index ? puzzle_input[column_index][left_index] : nil)
          right_point = (right_index <= max_row_index ? puzzle_input[column_index][right_index] : nil)
          low_points << row_info if row_info < [up_point, down_point, left_point, right_point].compact.min
        end
      end

      low_points
    end

    def input_file_to_hash_for_part_two(input_file)
      output = {}
      CSV.read(input_file).each_with_index do |values, index|
        output[index] = []
        (1..values.first.size).each do |n|
          output[index] << { value: values.first[n - 1].to_i, counted: false }
        end
      end
      output
    end

    def puzzle_input_two
      @puzzle_input_two ||= original_puzzle_input_part_two.dup
    end

    def add_to_basins(column_index, row_index)
      new_basin = []
      new_basin << { column: column_index, row: row_index }
      puzzle_input_two[column_index][row_index][:counted] = true

      add_other_points_to_new_basin(starting_point: new_basin.first, new_basin: new_basin)

      basins << new_basin
    end

    def basins
      @basins ||= []
    end

    def add_other_points_to_new_basin(starting_point:, new_basin:) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      col = starting_point[:column]
      row = starting_point[:row]
      up = {
        col: col - 1,
        row: row
      }
      up_point = puzzle_input_two&.dig(up[:col])&.dig(up[:row]) if up[:col] >= 0 && up[:row] >= 0

      down = {
        col: col + 1,
        row: row
      }
      down_point = puzzle_input_two&.dig(down[:col])&.dig(down[:row]) if down[:col] >= 0 && down[:row] >= 0

      left = {
        col: col,
        row: row - 1
      }
      left_point = puzzle_input_two&.dig(left[:col])&.dig(left[:row]) if left[:col] >= 0 && left[:row] >= 0

      right = {
        col: col,
        row: row + 1
      }
      right_point = puzzle_input_two&.dig(right[:col])&.dig(right[:row]) if right[:col] >= 0 && right[:row] >= 0

      record_point_in_basin(point: up_point, basin: new_basin, coordinates: up) if in_a_basin?(up_point)
      record_point_in_basin(point: down_point, basin: new_basin, coordinates: down) if in_a_basin?(down_point)
      record_point_in_basin(point: left_point, basin: new_basin, coordinates: left) if in_a_basin?(left_point)
      record_point_in_basin(point: right_point, basin: new_basin, coordinates: right) if in_a_basin?(right_point)
    end

    def in_a_basin?(point)
      return false if point.nil? || point[:counted] || point[:value] == NOT_A_BASIN

      true
    end

    def record_point_in_basin(point:, basin:, coordinates:)
      basin << { column: coordinates[:col], row: coordinates[:row] }
      point[:counted] = true
      add_other_points_to_new_basin(
        starting_point: { column: coordinates[:col], row: coordinates[:row] }, new_basin: basin
      )
    end

    def part_one
      sum_of_risk_level(find_low_points(cave_floor_heightmap))
    end

    def part_two
      puzzle_input_two.each do |column_index, column_info|
        column_info.each_with_index do |row_info, row_index|
          add_to_basins(column_index, row_index) if row_info[:value] != NOT_A_BASIN && row_info[:counted] == false
          row_info[:counted] = true
        end
      end

      basins.map(&:size).sort.last(3).inject(:*)
    end
  end
end
