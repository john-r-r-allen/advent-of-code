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
      duplicated_items_in_rucksacks.map { |item| item_priority(item) }.sum
    end

    def duplicated_items_in_rucksacks
      @dupllicated_items_in_rucksacks = []

      items_in_rucksack.each do |rucksack_items|
        items_in_rucksack = rucksack_items.size
        items_per_container = items_in_rucksack / 2
        container_one = rucksack_items.split("").first(items_per_container)
        container_two = rucksack_items.split("").last(items_per_container)

        @dupllicated_items_in_rucksacks << container_one.select { |item| container_two.include?(item) }.uniq.first
      end

      @dupllicated_items_in_rucksacks
    end

    def part_two
      nil
    end
  end
end
