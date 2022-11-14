require 'csv'
require 'pry'

class DayEleven # rubocop:disable Style/Documentation, Metrics/ClassLength
  SAMPLE_INPUT_FILE = '../../inputs/sample_inputs/day_11.csv'.freeze
  INPUT_FILE = '../../inputs/day_11.csv'.freeze

  attr_reader :total_flashes

  def initialize(total_flashes)
    @total_flashes = total_flashes
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
    @puzzle_input ||= input_file_to_hash(INPUT_FILE)
  end

  def reset_all_octopuses_flash_for_new_turn
    puzzle_input.each do |_column_index, column_info|
      column_info.each_with_index do |octopus_hash, _row_index|
        octopus_hash[:flashed_during_turn] = false
      end
    end
  end

  def step(debugging: false)
    puzzle_input.each do |column_index, column_info|
      column_info.each_with_index do |octopus_hash, row_index|
        # puts "step method: Octopus hash #{octopus_hash} while processing row index: #{row_index} and column index #{column_index}" if debugging # rubocop:disable Layout/LineLength
        octopus_hash[:energy_level] += 1 unless octopus_hash[:flashed_during_turn]
        next unless octopus_hash[:energy_level] > 9 && !octopus_hash[:flashed_during_turn]

        octopus_flash(col: column_index, row: row_index, debugging: debugging)
        # puts "step method: Octopus hash proccessed. New octopus has: #{octopus_hash}" if debugging
      end
    end

    reset_all_octopuses_flash_for_new_turn
  end

  def octopus_flash(col:, row:, debugging: false)
    increment_total_flashes
    puts "octopus_flash method: total flashes after increment: #{total_flashes}" if debugging
    puzzle_input[col][row][:flashed_during_turn] = true
    puzzle_input[col][row][:energy_level] = 0

    increment_energy_levels_for_surrounding_octopuses(col: col, row: row, debugging: debugging)
  end

  def increment_energy_levels_for_surrounding_octopuses(col:, row:, debugging: false) # rubocop:disable Metrics/AbcSize
    increment_octopus(col: col - 1, row: row - 1, debugging: debugging) # up and left
    increment_octopus(col: col - 1, row: row, debugging: debugging) # up
    increment_octopus(col: col - 1, row: row + 1, debugging: debugging) # up and right
    increment_octopus(col: col, row: row - 1, debugging: debugging) # left
    increment_octopus(col: col, row: row + 1, debugging: debugging) # right
    increment_octopus(col: col + 1, row: row - 1, debugging: debugging) # down and left
    increment_octopus(col: col + 1, row: row, debugging: debugging) # down
    increment_octopus(col: col + 1, row: row + 1, debugging: debugging) # down and right
  end

  def increment_octopus(col:, row:, debugging: false)
    return unless col >= 0 && row >= 0

    octopus = puzzle_input[col]&.dig(row)
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
      pretty_print_puzzle_input(step_number + 1)
      return (step_number + 1) if puzzle_numbers_synchronized?
    end
  end

  def puzzle_numbers_synchronized?
    energy_level = nil
    puzzle_input.each do |_index, array|
      (array.size).times do |array_index|
        energy_level = array[array_index][:energy_level] if energy_level.nil?

        return false if energy_level != array[array_index][:energy_level]
      end
    end
  end

  def pretty_print_puzzle_input(step_number)
    puts "\n\tPuzzle Input after #{step_number} step#{step_number > 1 ? 's' : ''}"
    puzzle_input.each do |_index, array|
      numbers = "\t"
      (array.size).times do |array_index|
        numbers += "#{array[array_index][:energy_level]} "
      end
      puts numbers
    end
    puts ''
  end

  def part_two(debugging: false)
    if debugging
      debugging_logs = StringIO.new
      $stdout = debugging_logs
    end

    puts "Part two: Number of steps to synchronization: #{run_steps(number_of_steps: 10_000, debugging: debugging)}"

    File.open('../../outputs/day_11_debugging_logs.txt', 'w') { |f| f.write debugging_logs.string } if debugging
  end
end

DayEleven.new(0).part_two(debugging: true)
