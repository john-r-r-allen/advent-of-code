module AdventOfCode
  class DayTen # rubocop:disable Metrics/ClassLength
    OPENING_SYMBOLS = %w(\( [ { <).freeze
    CLOSE_SYMBOL_LOOKUP = {
      '(': ")",
      '[': "]",
      '{': "}",
      '<': ">"
    }.freeze
    ILLEGAL_SYMBOL_POINT_VALUES = {
      ')': 3,
      ']': 57,
      '}': 1197,
      '>': 25_137
    }.freeze
    COMPLETION_SYMBOL_POINT_VALUES = {
      ')': 1,
      ']': 2,
      '}': 3,
      '>': 4
    }.freeze

    attr_reader :original_puzzle_input

    def initialize(puzzle_input_path)
      @original_puzzle_input = input_file_to_hash(puzzle_input_path)
    end

    def input_file_to_hash(input_file)
      output = {}
      CSV.read(input_file).each_with_index do |values, index|
        output[index] = []
        (1..values.first.size).each do |n|
          output[index] << values.first[n - 1]
        end
      end
      output
    end

    def puzzle_input_part_one
      @puzzle_input_part_one ||= original_puzzle_input.dup
    end

    def process_puzzle_input_part_one
      puzzle_input_part_one.each do |line_number, line_info|
        process_line_for_part_one(number: line_number, info: line_info)
      end
    end

    def process_line_for_part_one(number:, info:) # rubocop:disable Metrics/MethodLength
      line = []
      first_illegal_characters[number] = nil
      info.each do |symbol|
        if OPENING_SYMBOLS.include?(symbol)
          line << symbol
          next
        end

        if symbol == CLOSE_SYMBOL_LOOKUP[line.last.to_sym]
          line.pop
          next
        end

        first_illegal_characters[number] = symbol
        break
      end
    end

    def first_illegal_characters
      @first_illegal_characters ||= {}
    end

    def sum_illegal_character_values
      sum = 0
      first_illegal_characters.each do |_index, symbol|
        sum += ILLEGAL_SYMBOL_POINT_VALUES[symbol&.to_sym].to_i
      end
      sum
    end

    def part_one
      process_puzzle_input_part_one
      sum_illegal_character_values
    end

    def puzzle_input_part_two
      @puzzle_input_part_two ||= original_puzzle_input.dup
    end

    def process_puzzle_input_part_two
      puzzle_input_part_two.each do |line_number, line_info|
        process_line_for_part_two(number: line_number, info: line_info)
      end
    end

    def process_line_for_part_two(number:, info:) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      line = []
      legal_remaining_characters[number] = nil
      first_illegal_characters[number] = nil
      info.each do |symbol|
        if OPENING_SYMBOLS.include?(symbol)
          line << symbol
          next
        end

        if symbol == CLOSE_SYMBOL_LOOKUP[line.last.to_sym]
          line.pop
          next
        end

        first_illegal_characters[number] = symbol
        puzzle_input_part_two.delete(number)
        break
      end
      legal_remaining_characters[number] = line if first_illegal_characters[number].nil?
    end

    def legal_remaining_characters
      @legal_remaining_characters ||= {}
    end

    def completion_symbols # rubocop:disable Metrics/MethodLength
      return @completion_symbols if defined?(@completion_symbols)

      @completion_symbols = {}
      legal_remaining_characters.each do |index, remaining_characters|
        next if remaining_characters.nil?

        @completion_symbols[index] = []
        (1..remaining_characters.size).each do |n|
          # need to go through backwards
          i = remaining_characters.size - n
          @completion_symbols[index] << CLOSE_SYMBOL_LOOKUP[remaining_characters[i].to_sym]
        end
      end

      @completion_symbols
    end

    def scored_legal_remaining_characters # rubocop:disable Metrics/MethodLength
      return @scored_legal_remaining_characters if defined?(@scored_legal_remaining_characters)

      @scored_legal_remaining_characters = {}
      completion_symbols.each do |index, symbols|
        @scored_legal_remaining_characters[index] = 0
        symbols.size.times do |n|
          @scored_legal_remaining_characters[index] = (
            (@scored_legal_remaining_characters[index] * 5) + COMPLETION_SYMBOL_POINT_VALUES[symbols[n].to_sym]
          )
        end
      end

      @scored_legal_remaining_characters
    end

    def middle_legal_character_values_score
      legal_character_scores[legal_character_scores.size / 2]
    end

    def legal_character_scores
      return @legal_character_scores if defined?(@legal_character_scores)

      @legal_character_scores = []
      scored_legal_remaining_characters.each do |_index, value|
        @legal_character_scores << value
      end

      @legal_character_scores.sort!
    end

    def part_two
      process_puzzle_input_part_two
      middle_legal_character_values_score
    end
  end
end
