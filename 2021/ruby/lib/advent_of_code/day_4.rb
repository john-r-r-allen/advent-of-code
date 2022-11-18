require 'csv'
require 'pry'

EMPTY_ARRAY = [].freeze
EMPTY_SPACE = ' '.freeze
UNMARKED_SPACE = 'NO'.freeze
MARKED_SPACE = 'YES'.freeze


def store_board(puzzle_input)
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
  i = 0
  (0..(puzzle_input.size / 6)).each do |_input|
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

def bingo?(bingo_board:) # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/MethodLength
  return true if bingo_board[:row_one].all? { |_spot, spot_info| spot_info[:marked] == MARKED_SPACE }
  return true if bingo_board[:row_two].all? { |_spot, spot_info| spot_info[:marked] == MARKED_SPACE }
  return true if bingo_board[:row_three].all? { |_spot, spot_info| spot_info[:marked] == MARKED_SPACE }
  return true if bingo_board[:row_four].all? { |_spot, spot_info| spot_info[:marked] == MARKED_SPACE }
  return true if bingo_board[:row_five].all? { |_spot, spot_info| spot_info[:marked] == MARKED_SPACE }
  return true if bingo_board.all? { |_row, row_info| row_info[:spot_one][:marked] == MARKED_SPACE }
  return true if bingo_board.all? { |_row, row_info| row_info[:spot_two][:marked] == MARKED_SPACE }
  return true if bingo_board.all? { |_row, row_info| row_info[:spot_three][:marked] == MARKED_SPACE }
  return true if bingo_board.all? { |_row, row_info| row_info[:spot_four][:marked] == MARKED_SPACE }
  return true if bingo_board.all? { |_row, row_info| row_info[:spot_five][:marked] == MARKED_SPACE }

  false
end

def total_of_unmarked_numbers(bingo_board:)
  sum = bingo_board[:row_one].sum { |_spot, spot_info| spot_info[:marked] == UNMARKED_SPACE ? spot_info[:number].to_i : 0 }
  sum += bingo_board[:row_two].sum { |_spot, spot_info| spot_info[:marked] == UNMARKED_SPACE ? spot_info[:number].to_i : 0 }
  sum += bingo_board[:row_three].sum { |_spot, spot_info| spot_info[:marked] == UNMARKED_SPACE ? spot_info[:number].to_i : 0 }
  sum += bingo_board[:row_four].sum { |_spot, spot_info| spot_info[:marked] == UNMARKED_SPACE ? spot_info[:number].to_i : 0 }
  sum += bingo_board[:row_five].sum { |_spot, spot_info| spot_info[:marked] == UNMARKED_SPACE ? spot_info[:number].to_i : 0 }

  sum
end

# Part 1
puzzle_input = CSV.read('../../inputs/input_day_4_2021.csv')
numbers_drawn = puzzle_input.shift
puzzle_input.shift if puzzle_input.first == EMPTY_ARRAY
boards = {}
populate_boards(puzzle_input, boards)
numbers_drawn.each do |number_drawn| # rubocop:disable Style/PercentLiteralDelimiters
  done = false
  boards.each do |board_number, board_hash|
    mark_number_in_board(number_drawn: number_drawn, bingo_board: board_hash)

    done = bingo?(bingo_board: board_hash)
    if done
      puts total_of_unmarked_numbers(bingo_board: board_hash) * number_drawn.to_i
      break
    end
  end
  break if done
end

# Part 2
puzzle_input = CSV.read('../../inputs/input_day_4_2021.csv')
numbers_drawn = puzzle_input.shift
puzzle_input.shift if puzzle_input.first == EMPTY_ARRAY
boards = {}
populate_boards(puzzle_input, boards)
numbers_drawn.each do |number_drawn| # rubocop:disable Style/PercentLiteralDelimiters
  done = false
  boards.each do |board_number, board_hash|
    mark_number_in_board(number_drawn: number_drawn, bingo_board: board_hash)

    if bingo?(bingo_board: board_hash)
      final_number = total_of_unmarked_numbers(bingo_board: board_hash) * number_drawn.to_i
      boards.delete(board_number)
      puts final_number if boards.empty?
    end
  end
end
