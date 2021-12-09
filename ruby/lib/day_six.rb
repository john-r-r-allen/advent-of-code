require 'csv'
require 'pry'

SAMPLE_INPUT_FILE = '../../inputs/sample_inputs/day_6.csv'.freeze
INPUT_FILE = '../../inputs/day_6.csv'.freeze

def read_inputs(input_file)
  CSV.read(input_file)
end