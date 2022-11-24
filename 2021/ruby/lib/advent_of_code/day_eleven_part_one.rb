module AdventOfCode
  class DayElevenPartOne
    attr_reader :total_flashes, :original_puzzle_input

    def initialize(total_flashes:, puzzle_input_path:)
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
        values.first.size.times do |n|
          output[index] << { energy_level: values.first[n].to_i, flashed_during_turn: false }
        end
      end
      output
    end

    def puzzle_input_part_one
      @puzzle_input_part_one ||= original_puzzle_input.dup
    end

    def reset_all_octopuses_flash_for_new_turn
      puzzle_input_part_one.each do |_column_index, column_info|
        column_info.each_with_index do |octopus_hash, _row_index|
          octopus_hash[:flashed_during_turn] = false
        end
      end
    end

    def step
      puzzle_input_part_one.each do |column_index, column_info|
        column_info.each_with_index do |octopus_hash, row_index|
          octopus_hash[:energy_level] += 1 unless octopus_hash[:flashed_during_turn]
          next unless octopus_hash[:energy_level] > 9 && !octopus_hash[:flashed_during_turn]

          octopus_flash(col: column_index, row: row_index)
        end
      end

      reset_all_octopuses_flash_for_new_turn
    end

    def octopus_flash(col:, row:)
      increment_total_flashes
      puzzle_input_part_one[col][row][:flashed_during_turn] = true
      puzzle_input_part_one[col][row][:energy_level] = 0

      increment_energy_levels_for_surrounding_octopuses(col: col, row: row)
    end

    def increment_energy_levels_for_surrounding_octopuses(col:, row:)
      (col - 1..col + 1).each do |column|
        (row - 1..row + 1).each do |new_row|
          next if column == col && new_row == row # Surrounding only, not self!

          increment_octopus(col: column, row: new_row)
        end
      end
    end

    def increment_octopus(col:, row:) # rubocop:disable Metrics/CyclomaticComplexity
      return if col.negative? || row.negative?

      octopus = puzzle_input_part_one[col]&.dig(row)
      return if octopus.nil?

      octopus[:energy_level] += 1 unless octopus[:flashed_during_turn]
      return unless octopus[:energy_level] > 9 && !octopus[:flashed_during_turn]

      octopus_flash(col: col, row: row)
    end

    def run_steps(number_of_steps:)
      number_of_steps.times { |_step_number| step }
    end

    def pretty_print_puzzle_input_part_one(_step_number)
      puzzle_input_part_one.each do |_index, array|
        numbers = "\t"
        array.size.times do |array_index|
          numbers += "#{array[array_index][:energy_level]} "
        end
        puts numbers
      end
      puts ""
    end

    def part_one
      run_steps(number_of_steps: 100)
      total_flashes
    end
  end
end
