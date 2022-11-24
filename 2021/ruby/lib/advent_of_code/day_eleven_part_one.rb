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
        (1..values.first.size).each do |n|
          output[index] << { energy_level: values.first[n - 1].to_i, flashed_during_turn: false }
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

    def step(debugging: false)
      puzzle_input_part_one.each do |column_index, column_info|
        column_info.each_with_index do |octopus_hash, row_index|
          octopus_hash[:energy_level] += 1 unless octopus_hash[:flashed_during_turn]
          next unless octopus_hash[:energy_level] > 9 && !octopus_hash[:flashed_during_turn]

          octopus_flash(col: column_index, row: row_index, debugging: debugging)
        end
      end

      reset_all_octopuses_flash_for_new_turn
    end

    def octopus_flash(col:, row:, debugging: false)
      increment_total_flashes
      puts "octopus_flash method: total flashes after increment: #{total_flashes}" if debugging
      puzzle_input_part_one[col][row][:flashed_during_turn] = true
      puzzle_input_part_one[col][row][:energy_level] = 0

      increment_energy_levels_for_surrounding_octopuses(col: col, row: row)
    end

    def increment_energy_levels_for_surrounding_octopuses(col:, row:) # rubocop:disable Metrics/AbcSize
      increment_octopus(col: col - 1, row: row - 1) # up and left
      increment_octopus(col: col - 1, row: row) # up
      increment_octopus(col: col - 1, row: row + 1) # up and right
      increment_octopus(col: col, row: row - 1) # left
      increment_octopus(col: col, row: row + 1) # right
      increment_octopus(col: col + 1, row: row - 1) # down and left
      increment_octopus(col: col + 1, row: row) # down
      increment_octopus(col: col + 1, row: row + 1) # down and right
    end

    def increment_octopus(col:, row:) # rubocop:disable Metrics/CyclomaticComplexity
      return unless col >= 0 && row >= 0

      octopus = puzzle_input_part_one[col]&.dig(row)
      return if octopus.nil?

      octopus[:energy_level] += 1 unless octopus[:flashed_during_turn]
      return unless octopus[:energy_level] > 9 && !octopus[:flashed_during_turn]

      octopus_flash(col: col, row: row)
    end

    def run_steps(number_of_steps:, debugging: false)
      number_of_steps.times do |step_number|
        puts "Step number #{step_number + 1} begin. Total flashes: #{total_flashes}" if debugging
        step(debugging: debugging)
        puts "Step number #{step_number + 1} end. Total flashes: #{total_flashes}" if debugging
        pretty_print_puzzle_input_part_one(step_number + 1) if debugging
      end
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

    def part_one(debugging: false)
      if debugging
        debugging_logs = StringIO.new
        $stdout = debugging_logs
      end

      run_steps(number_of_steps: 100, debugging: debugging)
      puts "Part one: Number of flashes after 100 steps: #{total_flashes}" if debugging
      File.open("../../outputs/day_11_debugging_logs.txt", "w") { |f| f.write debugging_logs.string } if debugging

      total_flashes
    end
  end
end
