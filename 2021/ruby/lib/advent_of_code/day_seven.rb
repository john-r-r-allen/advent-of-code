require 'csv'
require 'pry'

SAMPLE_INPUT_FILE = '../../inputs/sample_inputs/day_seven.csv'.freeze
INPUT_FILE = '../../inputs/day_seven.csv'.freeze

def input_file_to_array(input_file)
  CSV.read(input_file).first.map(&:to_i)
end

def determine_total_fuel_cost_for_part_1(crab_positions:)
  fuel_costs = {}
  (crab_positions.min..crab_positions.max).each do |position|
    fuel_costs[position] = 0

    crab_positions.each do |crab_position|
      fuel_costs[position] += (crab_position - position).abs
    end
  end

  fuel_costs
end

puzzle_input = input_file_to_array(INPUT_FILE)
total_fuel_cost = determine_total_fuel_cost_for_part_1(crab_positions: puzzle_input)
# puts "#{total_fuel_cost}"
puts "Part 1: Best position and cost: #{total_fuel_cost.min_by { |_k, v| v }}"

# ============================================================================
# Part 2
# ============================================================================
def determine_total_fuel_cost_for_part_2(crab_positions:, debugging: false)
  fuel_costs = {}
  puts "Min Crab Position: #{crab_positions.min}" if debugging
  puts "Max Crab Position: #{crab_positions.max}" if debugging
  (crab_positions.min..crab_positions.max).each do |position|
    fuel_costs[position] = 0

    puts "#{DateTime.now}: Calculating cost for position: #{position}"
    crab_positions.each do |crab_position|
      (1..(crab_position - position).abs).each do |moves_away|
        fuel_costs[position] += moves_away
      end
    end
  end

  puts "#{fuel_costs}" if debugging
  fuel_costs
end

puzzle_input = input_file_to_array(INPUT_FILE)
total_fuel_cost = determine_total_fuel_cost_for_part_2(crab_positions: puzzle_input, debugging: true)
puts "Part 2: Best position and cost: #{total_fuel_cost.min_by { |_k, v| v }}"
