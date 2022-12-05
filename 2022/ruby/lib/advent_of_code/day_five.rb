module AdventOfCode
  class DayFive
    attr_reader :stacked_crates, :instructions, :stacked_crates_set

    def initialize(puzzle_input_path)
      @stacked_crates = {}
      @instructions = []
      @stacked_crates_set = false
      ingest_puzzle_input_file(puzzle_input_path)
    end

    def ingest_puzzle_input_file(puzzle_input_path) # rubocop:disable Metrics/MethodLength
      crates_and_instruction = CSV.read(puzzle_input_path).map(&:first)
      crates_and_instruction.each do |line|
        if line.nil?
          @stacked_crates_set = true
          next
        end

        if stacked_crates_set
          process_line_for_instructions(line)
        else
          process_line_for_stacked_crates(line)
        end
      end
    end

    def process_line_for_stacked_crates(line)
      if line.include?("[")
        add_crates_from_line(line)
      else
        ensure_crate_stack_keys_correct(line)
      end
    end

    def add_crates_from_line(line)
      stacks_represented_in_line = ((line.size - 3) / 4) + 1
      stacks_represented_in_line.times do |i|
        stack_number = i + 1
        crate_start = i * 4
        crate_end = crate_start + 2
        crate = line[crate_start..crate_end]
        letter = crate[1]
        @stacked_crates[stack_number] ||= []
        @stacked_crates[stack_number].prepend(letter) unless crate.blank?
      end
    end

    def ensure_crate_stack_keys_correct(line)
      line.split(" ").each_with_index do |crate_key, index|
        raise "Crate key not a number. Breaks assumptions." if crate_key.to_i.zero? && crate_key != "0"
        raise "Crate key not index + 1. Assumptions broken." if crate_key.to_i != index + 1
      end
    end

    def process_line_for_instructions(line)
      move_location_in_string = line.index("move")
      from_location_in_string = line.index("from")
      to_location_in_string = line.index("to")
      number_of_crates_to_move = line[(move_location_in_string + 5)..(from_location_in_string - 2)].to_i
      from_stack = line[(from_location_in_string + 5)..(to_location_in_string - 2)].to_i
      to_stack = line[(to_location_in_string + 3)..].to_i
      @instructions << { crates: number_of_crates_to_move, from: from_stack, to: to_stack }
    end

    def part_one
      instructions.each do |instruction|
        instruction[:crates].times do
          crate_to_move = stacked_crates[instruction[:from]].pop
          @stacked_crates[instruction[:to]] << crate_to_move
        end
      end
      stacked_crates.map { |_k, v| v.last }.join
    end

    def part_two
      instructions.each do |instruction|
        crates_to_move = stacked_crates[instruction[:from]].pop(instruction[:crates])
        crates_to_move.each { |crate| @stacked_crates[instruction[:to]] << crate }
      end
      stacked_crates.map { |_k, v| v.last }.join
    end
  end
end
