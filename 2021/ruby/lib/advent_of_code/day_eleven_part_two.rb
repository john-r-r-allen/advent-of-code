module AdventOfCode
  class DayElevenPartTwo
    attr_reader :total_flashes, :original_puzzle_input

    def initialize(puzzle_input_path:, total_flashes:)
      @total_flashes = total_flashes
      @original_puzzle_input = input_file_to_hash(puzzle_input_path)
    end

    def increment_total_flashes
      @total_flashes += 1
    end

    def input_file_to_hash(input_file)
      output = {}
      CSV.read(input_file).each_with_index do |values, index|
        output[index] = []
        (1..values.first.size).each do |n|
          output[index] << { energy_level: values.first[n - 1].to_i, flashed_during_turn: false }
        end
      end
      output
    end

    def puzzle_input
      @puzzle_input ||= original_puzzle_input.dup
    end

    def reset_octopus_flash
      puzzle_input.each do |_column_index, column_info|
        column_info.each_with_index do |octopus_hash, _row_index|
          octopus_hash[:flashed_during_turn] = false
        end
      end
    end

    def step
      puzzle_input.each do |column_index, column_info|
        column_info.each_with_index do |octopus_hash, row_index|
          octopus_hash[:energy_level] += 1 unless octopus_hash[:flashed_during_turn]
          next unless octopus_hash[:energy_level] > 9 && !octopus_hash[:flashed_during_turn]

          octopus_flash(col: column_index, row: row_index)
        end
      end

      reset_octopus_flash
    end

    def octopus_flash(col:, row:)
      increment_total_flashes
      puzzle_input[col][row][:flashed_during_turn] = true
      puzzle_input[col][row][:energy_level] = 0

      increment_energy_levels_for_surrounding_octopuses(column: col, row: row)
    end

    def increment_energy_levels_for_surrounding_octopuses(column:, row:)
      (column - 1..column + 1).each do |new_column|
        (row - 1..row + 1).each do |new_row|
          next if new_column == column && new_row == row # Surrounding only, not self!

          increment_octopus(col: new_column, row: new_row)
        end
      end
    end

    def increment_octopus(col:, row:) # rubocop:disable Metrics/CyclomaticComplexity
      return if col.negative? || row.negative?

      octopus = puzzle_input[col]&.dig(row)
      return if octopus.nil?

      octopus[:energy_level] += 1 unless octopus[:flashed_during_turn]
      return unless octopus[:energy_level] > 9 && !octopus[:flashed_during_turn]

      octopus_flash(col: col, row: row)
    end

    def run_steps(number_of_steps:)
      number_of_steps.times do |step_number|
        step
        return (step_number + 1) if puzzle_numbers_synchronized?
      end
    end

    def puzzle_numbers_synchronized?
      energy_level = nil
      puzzle_input.each do |_index, array|
        array.size.times do |array_index|
          energy_level = array[array_index][:energy_level] if energy_level.nil?

          return false if energy_level != array[array_index][:energy_level]
        end
      end
    end

    def part_two
      run_steps(number_of_steps: 10_000)
    end
  end
end
