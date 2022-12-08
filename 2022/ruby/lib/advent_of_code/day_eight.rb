module AdventOfCode
  class DayEight # rubocop:disable Metrics/ClassLength
    attr_reader :tree_map

    def initialize(puzzle_input_path)
      @tree_map = process_puzzle_input(puzzle_input_path)
    end

    def process_puzzle_input(puzzle_input_path)
      CSV.read(puzzle_input_path).map(&:first).map { |row| row.split("").map(&:to_i) }
    end

    def part_one
      visible_trees = 0
      tree_map.each_with_index do |row, tree_row_index|
        row.each_with_index do |tree_height, tree_column_index|
          visible_trees += 1 if tree_visible?(tree_row_index:, tree_column_index:, tree_height:)
        end
      end
      visible_trees
    end

    def tree_visible?(tree_row_index:, tree_column_index:, tree_height:) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return true if tree_row_index.zero? || tree_row_index == max_tree_row_index
      return true if tree_column_index.zero? || tree_column_index == max_tree_column_index
      return true if trees_up_shorter?(tree_row_index:, tree_column_index:, tree_height:)
      return true if trees_right_shorter?(tree_row_index:, tree_column_index:, tree_height:)
      return true if trees_left_shorter?(tree_row_index:, tree_column_index:, tree_height:)
      return true if trees_down_shorter?(tree_row_index:, tree_column_index:, tree_height:)

      false
    end

    def trees_up_shorter?(tree_row_index:, tree_column_index:, tree_height:)
      (0...tree_row_index).each do |i|
        return false unless tree_map[i][tree_column_index] < tree_height
      end

      true
    end

    def trees_right_shorter?(tree_row_index:, tree_column_index:, tree_height:)
      ((tree_column_index + 1)..max_tree_column_index).each do |i|
        return false unless tree_map[tree_row_index][i] < tree_height
      end

      true
    end

    def trees_left_shorter?(tree_row_index:, tree_column_index:, tree_height:)
      (0...tree_column_index).each do |i|
        return false unless tree_map[tree_row_index][i] < tree_height
      end

      true
    end

    def trees_down_shorter?(tree_row_index:, tree_column_index:, tree_height:)
      ((tree_row_index + 1)..max_tree_row_index).each do |i|
        return false unless tree_map[i][tree_column_index] < tree_height
      end

      true
    end

    def max_tree_row_index
      tree_row_count - 1
    end

    def max_tree_column_index
      tree_column_count - 1
    end

    def tree_row_count
      @tree_row_count ||= tree_map.size
    end

    def tree_column_count
      @tree_column_count ||= tree_map.first.size
    end

    def part_two
      highest_scenic_score = 0
      tree_map.each_with_index do |row, tree_row_index|
        row.each_with_index do |tree_height, tree_column_index|
          scenic_score = determine_tree_scenic_score(tree_row_index:, tree_column_index:, tree_height:)
          highest_scenic_score = [highest_scenic_score, scenic_score].max
        end
      end
      highest_scenic_score
    end

    def determine_tree_scenic_score(tree_row_index:, tree_column_index:, tree_height:)
      trees_visible_up(tree_row_index:, tree_column_index:, tree_height:) *
        trees_visible_down(tree_row_index:, tree_column_index:, tree_height:) *
        trees_visible_right(tree_row_index:, tree_column_index:, tree_height:) *
        trees_visible_left(tree_row_index:, tree_column_index:, tree_height:)
    end

    def trees_visible_up(tree_row_index:, tree_column_index:, tree_height:)
      visible_trees = 0
      (tree_row_index + 1).times do |i|
        next if i.zero?

        visible_trees += 1
        break if tree_map[tree_row_index - i][tree_column_index] >= tree_height
      end
      visible_trees
    end

    def trees_visible_down(tree_row_index:, tree_column_index:, tree_height:)
      visible_trees = 0
      (max_tree_row_index - tree_row_index + 1).times do |i|
        next if i.zero?

        visible_trees += 1
        break if tree_map[tree_row_index + i][tree_column_index] >= tree_height
      end
      visible_trees
    end

    def trees_visible_right(tree_row_index:, tree_column_index:, tree_height:)
      visible_trees = 0
      (max_tree_column_index - tree_column_index + 1).times do |i|
        next if i.zero?

        visible_trees += 1
        break if tree_map[tree_row_index][tree_column_index + i] >= tree_height
      end
      visible_trees
    end

    def trees_visible_left(tree_row_index:, tree_column_index:, tree_height:)
      visible_trees = 0
      (tree_column_index + 1).times do |i|
        next if i.zero?

        visible_trees += 1
        break if tree_map[tree_row_index][tree_column_index - i] >= tree_height
      end
      visible_trees
    end
  end
end
