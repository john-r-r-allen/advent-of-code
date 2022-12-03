module AdventOfCode
  class DayThree
    GROUP_SIZE = 3
    LETTERS_IN_PRIORITY_ORDER = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".freeze

    attr_reader :rucksacks

    def initialize(puzzle_input_path)
      @rucksacks = CSV.read(puzzle_input_path).map { |row| row.first.split("") }
    end

    def item_priority(original_item)
      LETTERS_IN_PRIORITY_ORDER.split("").each_with_index do |item, index|
        priority = index + 1
        return priority if item == original_item
      end
    end

    def part_one
      repeated_items_in_rucksacks.map { |item| item_priority(item) }.sum
    end

    def repeated_items_in_rucksacks
      @repeated_items_in_rucksacks ||= rucksacks.map do |rucksack|
        rucksack_container_one(rucksack).intersection(rucksack_container_two(rucksack)).uniq.first
      end
    end

    def rucksack_container_one(rucksack)
      rucksack.first(items_in_rucksack_container(rucksack))
    end

    def rucksack_container_two(rucksack)
      rucksack.last(items_in_rucksack_container(rucksack))
    end

    def items_in_rucksack_container(rucksack)
      rucksack.size / 2
    end

    def part_two
      group_items.map { |item| item_priority(item) }.sum
    end

    def group_items
      @group_items ||= groups.map do |group|
        group_intersection = group.flatten
        group.map { |group_part| group_intersection = group_intersection.intersection(group_part) }
        group_intersection.first
      end
    end

    def groups
      return @groups if defined?(@groups)

      @groups = []
      number_of_groups.times do |group_number|
        @groups << rucksacks[first_in_group(group_number)..last_in_group(group_number)]
      end

      @groups
    end

    def first_in_group(group_number)
      group_number * GROUP_SIZE
    end

    def last_in_group(group_number)
      first_in_group(group_number) + GROUP_SIZE - 1
    end

    def number_of_groups
      raise "Last group is not a full group!" if rucksacks.size % GROUP_SIZE != 0

      rucksacks.size / GROUP_SIZE
    end
  end
end
