require "csv"

module AdventOfCode
  class DayFive # rubocop:disable Metrics/ClassLength
    attr_reader :hydrothermal_vents

    def initialize(puzzle_input_path)
      @hydrothermal_vents = file_to_array(puzzle_input_path)
    end

    def part_one
      diagram = produce_diagram(min_x: min_x_value, min_y: min_y_value, max_x: max_x_value, max_y: max_y_value)
      hydrothermal_vents.each do |coordinates|
        mark_lines_on_diagram_for_part_one(diagram: diagram, coordinates: coordinates)
      end

      find_number_of_multiple_hit_locations(diagram: diagram)
    end

    def part_two
      diagram = produce_diagram(min_x: min_x_value, min_y: min_y_value, max_x: max_x_value, max_y: max_y_value)
      hydrothermal_vents.each do |coordinates|
        mark_lines_on_diagram_for_part_two(diagram: diagram, coordinates: coordinates)
      end

      find_number_of_multiple_hit_locations(diagram: diagram)
    end

    def min_x_value
      [
        hydrothermal_vents.map { |hydrothermal_vent| hydrothermal_vent[:x1] }.min,
        hydrothermal_vents.map { |hydrothermal_vent| hydrothermal_vent[:x2] }.min
      ].min
    end

    def max_x_value
      [
        hydrothermal_vents.map { |hydrothermal_vent| hydrothermal_vent[:x1] }.max,
        hydrothermal_vents.map { |hydrothermal_vent| hydrothermal_vent[:x2] }.max
      ].max
    end

    def min_y_value
      [
        hydrothermal_vents.map { |hydrothermal_vent| hydrothermal_vent[:y1] }.min,
        hydrothermal_vents.map { |hydrothermal_vent| hydrothermal_vent[:y2] }.min
      ].min
    end

    def max_y_value
      [
        hydrothermal_vents.map { |hydrothermal_vent| hydrothermal_vent[:y1] }.max,
        hydrothermal_vents.map { |hydrothermal_vent| hydrothermal_vent[:y2] }.max
      ].max
    end

    def file_to_array(input_file) # rubocop:disable Metrics/AbcSize
      temp = []
      output = []

      CSV.read(input_file).each do |value_array|
        temp << value_array.map { |value| value.gsub(" -> ", ",").split(",") }.flatten
      end

      temp.each do |value|
        output << {
          x1: value[0].to_i,
          y1: value[1].to_i,
          x2: value[2].to_i,
          y2: value[3].to_i
        }
      end

      output
    end

    def produce_diagram(min_x:, min_y:, max_x:, max_y:)
      temp = {}

      (min_x..max_x).each do |x|
        temp[x] = {}
        (min_y..max_y).each do |y|
          temp[x][y] = 0
        end
      end

      temp
    end

    def mark_lines_on_diagram_for_part_one(diagram:, coordinates:) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      x1 = coordinates[:x1]
      x2 = coordinates[:x2]
      y1 = coordinates[:y1]
      y2 = coordinates[:y2]

      return if x1 != x2 && y1 != y2

      if x1 == x2
        y_values = [y1, y2]
        (y_values.min..y_values.max).each do |y|
          diagram[x1][y] += 1
        end
      end

      return unless y1 == y2

      x_values = [x1, x2]
      (x_values.min..x_values.max).each do |x|
        diagram[x][y1] += 1
      end
    end

    def mark_lines_on_diagram_for_part_two(diagram:, coordinates:) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
      x1 = coordinates[:x1]
      x2 = coordinates[:x2]
      y1 = coordinates[:y1]
      y2 = coordinates[:y2]

      if x1 == x2
        y_values = [y1, y2]
        (y_values.min..y_values.max).each do |y|
          diagram[x1][y] += 1
        end
      end

      if y1 == y2
        x_values = [x1, x2]
        (x_values.min..x_values.max).each do |x|
          diagram[x][y1] += 1
        end
      end

      return unless x1 != x2 && y1 != y2

      slope = (y2 - y1) / (x2 - x1)

      if x1 < x2
        (x1..x2).each do |x|
          calculated_y = y1 + ((x - x1) * slope)
          diagram[x][calculated_y] += 1
        end
      else
        (x2..x1).each do |x|
          calculated_y = y2 + ((x - x2) * slope)
          diagram[x][calculated_y] += 1
        end
      end
    end

    def find_number_of_multiple_hit_locations(diagram:)
      counter = 0

      diagram.each do |row_index, row|
        row.each do |column_index, _column|
          counter += 1 if diagram[row_index][column_index] > 1
        end
      end

      counter
    end
  end
end
