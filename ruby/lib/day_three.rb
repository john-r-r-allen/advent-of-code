require 'csv'

puzzle_input = CSV.read('../../inputs/input_day_3_2021.csv').map { |input| input.first }

gamma_rate_binary = ''
epsilon_rate_binary = ''

bit_one_values = {}
bit_zero_values = {}
positions_in_string = puzzle_input.first.size - 1

(0..positions_in_string).each do |i|
  bit_one_values[i + 1] = 0
  bit_zero_values[i + 1] = 0
  puzzle_input.each do |input|
    bit_one_values[i + 1] += 1 if input[i] == '1'
    bit_zero_values[i + 1] += 1 if input[i] == '0'
  end

  if bit_one_values[i + 1] > bit_zero_values[i + 1]
    gamma_rate_binary += '1'
    epsilon_rate_binary += '0'
  else
    gamma_rate_binary += '0'
    epsilon_rate_binary += '1'
  end
end

puts "Part 1: Power Consumption: #{gamma_rate_binary.to_i(2) * epsilon_rate_binary.to_i(2)}"

# ============================================================================

def part_two_array_bit_looping(puzzle_input, value_for_more_bit_one = '1', value_for_less_bit_one = '0') # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  new_puzzle_input = puzzle_input
  bit_one_values = {}
  bit_zero_values = {}
  output_binary = ''
  positions_in_string = puzzle_input.first.size - 1
  (0..positions_in_string).each do |n|
    bit_one_values[n + 1] = 0
    bit_zero_values[n + 1] = 0
    new_puzzle_input.each do |input|
      bit_one_values[n + 1] += 1 if input[n] == '1'
      bit_zero_values[n + 1] += 1 if input[n] == '0'
    end

    output_binary +=
      if bit_one_values[n + 1] >= bit_zero_values[n + 1]
        value_for_more_bit_one
      else
        value_for_less_bit_one
      end

    temp = new_puzzle_input.find_all { |input| input[0..n] == output_binary }
    new_puzzle_input = temp
    output_binary = temp.first if temp.size == 1
    break if temp.size == 1
  end

  output_binary
end

oxygen_generator_rate = part_two_array_bit_looping(puzzle_input).to_i(2)
co2_scrubber_rating = part_two_array_bit_looping(puzzle_input, '0', '1').to_i(2)

life_support_rating = oxygen_generator_rate * co2_scrubber_rating

puts "Part 2: Life Support Rating: #{life_support_rating}"
