module AdventOfCode
  class DayThree
    attr_reader :items_in_rucksack

    def initialize(puzzle_input_path)
      @items_in_rucksack = CSV.read(puzzle_input_path).map(&:first)
    end

    def item_priority(original_item)
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split("").each_with_index do |item, index|
        priority = index + 1
        return priority if item == original_item
      end
    end

    def part_one
      nil
    end

    def part_two
      nil
    end
  end
end
