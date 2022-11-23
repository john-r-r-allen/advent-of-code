require "csv"

module AdventOfCode
  class DayFour # rubocop:disable Metrics/ClassLength
    EMPTY_ARRAY = [].freeze
    EMPTY_SPACE = " ".freeze
    UNMARKED_SPACE = "NO".freeze
    MARKED_SPACE = "YES".freeze

    attr_accessor :original_bingo_input

    def initialize(puzzle_input_path)
      @original_bingo_input = CSV.read(puzzle_input_path)
    end

    def part_one
      puzzle_input = @original_bingo_input.dup
      numbers_drawn = puzzle_input.shift
      puzzle_input.shift if puzzle_input.first == EMPTY_ARRAY
      boards = {}
      populate_boards(puzzle_input, boards)
      numbers_drawn.each do |number_drawn|
        boards.each do |_board_number, board_hash|
          mark_number_in_board(number_drawn: number_drawn, bingo_board: board_hash)

          if bingo?(bingo_board: board_hash)
            return total_of_unmarked_numbers(bingo_board: board_hash) * number_drawn.to_i
          end
        end
      end
    end

    def part_two
      puzzle_input = @original_bingo_input.dup
      numbers_drawn = puzzle_input.shift
      puzzle_input.shift if puzzle_input.first == EMPTY_ARRAY
      boards = {}
      populate_boards(puzzle_input, boards)
      numbers_drawn.each do |number_drawn|
        boards.each do |board_number, board_hash|
          mark_number_in_board(number_drawn: number_drawn, bingo_board: board_hash)
          next unless bingo?(bingo_board: board_hash)

          final_number = total_of_unmarked_numbers(bingo_board: board_hash) * number_drawn.to_i
          boards.delete(board_number)
          return final_number if boards.empty?
        end
      end
    end

    def store_board(puzzle_input) # rubocop:disable Metrics/AbcSize
      row_one_numbers = puzzle_input.shift.first.split(EMPTY_SPACE)
      row_two_numbers = puzzle_input.shift.first.split(EMPTY_SPACE)
      row_three_numbers = puzzle_input.shift.first.split(EMPTY_SPACE)
      row_four_numbers = puzzle_input.shift.first.split(EMPTY_SPACE)
      row_five_numbers = puzzle_input.shift.first.split(EMPTY_SPACE)
      {
        row_one: {
          spot_one: {
            number: row_one_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_two: {
            number: row_one_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_three: {
            number: row_one_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_four: {
            number: row_one_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_five: {
            number: row_one_numbers.shift,
            marked: UNMARKED_SPACE
          }
        },
        row_two: {
          spot_one: {
            number: row_two_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_two: {
            number: row_two_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_three: {
            number: row_two_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_four: {
            number: row_two_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_five: {
            number: row_two_numbers.shift,
            marked: UNMARKED_SPACE
          }
        },
        row_three: {
          spot_one: {
            number: row_three_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_two: {
            number: row_three_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_three: {
            number: row_three_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_four: {
            number: row_three_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_five: {
            number: row_three_numbers.shift,
            marked: UNMARKED_SPACE
          }
        },
        row_four: {
          spot_one: {
            number: row_four_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_two: {
            number: row_four_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_three: {
            number: row_four_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_four: {
            number: row_four_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_five: {
            number: row_four_numbers.shift,
            marked: UNMARKED_SPACE
          }
        },
        row_five: {
          spot_one: {
            number: row_five_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_two: {
            number: row_five_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_three: {
            number: row_five_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_four: {
            number: row_five_numbers.shift,
            marked: UNMARKED_SPACE
          },
          spot_five: {
            number: row_five_numbers.shift,
            marked: UNMARKED_SPACE
          }
        }
      }
    end

    def populate_boards(puzzle_input, boards)
      ((puzzle_input.size / 6) + 1).times do |i|
        i += 1
        boards[i] = store_board(puzzle_input)
        puzzle_input.shift if puzzle_input.first == EMPTY_ARRAY
      end
    end

    def mark_number_in_board(number_drawn:, bingo_board:)
      bingo_board.each do |_row_key, row_hash|
        hits = row_hash.select { |_spot_key, spot_hash_value| spot_hash_value.key(number_drawn) }
        hits.each { |_key, value| value[:marked] = MARKED_SPACE }
      end
    end

    def bingo?(bingo_board:)
      any_vertical_bingos?(bingo_board) || any_horizontal_bingos?(bingo_board)
    end

    def any_vertical_bingos?(bingo_board)
      vertical_bingo?(bingo_board: bingo_board, spot: :spot_one) ||
        vertical_bingo?(bingo_board: bingo_board, spot: :spot_two) ||
        vertical_bingo?(bingo_board: bingo_board, spot: :spot_three) ||
        vertical_bingo?(bingo_board: bingo_board, spot: :spot_four) ||
        vertical_bingo?(bingo_board: bingo_board, spot: :spot_five)
    end

    def any_horizontal_bingos?(bingo_board)
      horizontal_bingo?(bingo_board[:row_one]) ||
        horizontal_bingo?(bingo_board[:row_two]) ||
        horizontal_bingo?(bingo_board[:row_three]) ||
        horizontal_bingo?(bingo_board[:row_four]) ||
        horizontal_bingo?(bingo_board[:row_five])
    end

    def vertical_bingo?(bingo_board:, spot:)
      bingo_board.all? { |_row, row_info| row_info[spot][:marked] == MARKED_SPACE }
    end

    def horizontal_bingo?(bingo_board_row)
      bingo_board_row.all? { |_spot, spot_info| spot_info[:marked] == MARKED_SPACE }
    end

    def total_of_unmarked_numbers(bingo_board:)
      sum_of_unmarked_numbers_on_bingo_board_row(bingo_board[:row_one]) +
        sum_of_unmarked_numbers_on_bingo_board_row(bingo_board[:row_two]) +
        sum_of_unmarked_numbers_on_bingo_board_row(bingo_board[:row_three]) +
        sum_of_unmarked_numbers_on_bingo_board_row(bingo_board[:row_four]) +
        sum_of_unmarked_numbers_on_bingo_board_row(bingo_board[:row_five])
    end

    def sum_of_unmarked_numbers_on_bingo_board_row(bingo_board_row)
      bingo_board_row.sum do |_spot, spot_info|
        spot_info[:marked] == UNMARKED_SPACE ? spot_info[:number].to_i : 0
      end
    end
  end
end
