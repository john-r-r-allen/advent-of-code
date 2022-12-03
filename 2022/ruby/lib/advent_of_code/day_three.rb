module AdventOfCode
  class DayThree
    GROUP_SIZE = 3

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
      repeated_items_in_rucksacks.map { |item| item_priority(item) }.sum
    end

    def repeated_items_in_rucksacks
      @repeated_items_in_rucksacks = []

      items_in_rucksack.each do |rucksack_items|
        items_in_rucksack = rucksack_items.size
        items_per_container = items_in_rucksack / 2
        container_one = rucksack_items.split("").first(items_per_container)
        container_two = rucksack_items.split("").last(items_per_container)

        @repeated_items_in_rucksacks << container_one.select { |item| container_two.include?(item) }.uniq.first
      end

      @repeated_items_in_rucksacks
    end

    def part_two
      items_carried_by_groups.map { |item| item_priority(item) }.sum
    end

    def items_carried_by_groups # rubocop:disable Metrics/AbcSize
      @items_carried_by_groups = []

      number_of_groups.times do |i|
        group_offset = i * 3
        rucksack_one = items_in_rucksack[group_offset].split("")
        rucksack_two = items_in_rucksack[group_offset + 1].split("")
        rucksack_three = items_in_rucksack[group_offset + 2].split("")
        @items_carried_by_groups << (rucksack_one & rucksack_two & rucksack_three).first
      end

      @items_carried_by_groups
    end

    def number_of_groups
      raise "Last group is not a full group!" if items_in_rucksack.size % GROUP_SIZE != 0

      items_in_rucksack.size / GROUP_SIZE
    end
  end
end
