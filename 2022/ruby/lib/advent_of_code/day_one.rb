module AdventOfCode
  class DayOne
    attr_reader :calories_held_by_elves

    def initialize(puzzle_inputh_path)
      @calories_held_by_elves = CSV.read(puzzle_inputh_path).map { |input| input.first }
    end

    def part_one
      max_calories_held_by_elf
    end

    def max_calories_held_by_elf
      calories_per_elf.values.max
    end

    def calories_per_elf
      return @calories_per_elf if defined?(@calories_per_elf)

      current_elf = 1
      @calories_per_elf = { 1 => 0 }
      calories_held_by_elves.each do |calories|
        if calories.nil?
          current_elf += 1
          @calories_per_elf[current_elf] = 0
          next
        end

        @calories_per_elf[current_elf] += calories.to_i
      end

      @calories_per_elf
    end

    def part_two
      calories_per_elf.values.max(3).sum
    end
  end
end
