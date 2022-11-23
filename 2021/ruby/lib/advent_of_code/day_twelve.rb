require 'csv'
require 'pry'

class DayTwelve # rubocop:disable Style/Documentation
  SAMPLE_INPUT_FILE = '../../inputs/sample_inputs/day_twelve.csv'.freeze
  INPUT_FILE = '../../inputs/day_twelve.csv'.freeze

  def initialize; end

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
    @puzzle_input ||= input_file_to_hash(SAMPLE_INPUT_FILE)
  end
end

DayTwelve.new.puzzle_input
