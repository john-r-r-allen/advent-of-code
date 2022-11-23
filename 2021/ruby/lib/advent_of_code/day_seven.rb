require "csv"

module AdventOfCode
  class DaySeven
    attr_reader :crab_positions

    def initialize(puzzle_input_path)
      @crab_positions = CSV.read(puzzle_input_path).first.map(&:to_i)
    end

    def part_one
      determine_total_fuel_cost_for_part_one(crab_positions).values.min
    end

    def determine_total_fuel_cost_for_part_one(crab_positions)
      fuel_costs = {}
      (crab_positions.min..crab_positions.max).each do |position|
        fuel_costs[position] = 0

        crab_positions.each do |crab_position|
          fuel_costs[position] += (crab_position - position).abs
        end
      end

      fuel_costs
    end

    def part_two
      determine_total_fuel_cost_for_part_two(crab_positions).values.min
    end

    def determine_total_fuel_cost_for_part_two(crab_positions)
      fuel_costs = {}
      (crab_positions.min..crab_positions.max).each do |position|
        fuel_costs[position] = 0

        crab_positions.each do |crab_position|
          fuel_costs[position] += (1..(crab_position - position).abs).sum
        end
      end

      fuel_costs
    end
  end
end
