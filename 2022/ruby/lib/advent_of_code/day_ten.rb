module AdventOfCode
  class DayTen
    NO_OP = "noop".freeze
    ADD_X = "addx".freeze

    attr_reader :cpu_instructions,
                :x_register,
                :signal_strengths,
                :cycles_waited,
                :cpu_instructions_position,
                :performing_add_x

    def initialize(cpu_instructions_path)
      @cpu_instructions = CSV.read(cpu_instructions_path).map(&:first)
      @x_register = 1
      @signal_strengths = []
      @cycles_waited = 0
      @cpu_instructions_position = 0
      @performing_add_x = false
    end

    def part_one
      determine_signal_strengths
      signal_strengths.sum
    end

    def determine_signal_strengths
      221.times do |cycle|
        next if cycle.zero?

        record_signal_strength(cycle) if check_signal_strength?(cycle)
        perform_cpu_instruction(cpu_instructions[cpu_instructions_position])
      end
    end

    def check_signal_strength?(cycle)
      return false if cycle > 220

      ((cycle - 20) % 40).zero?
    end

    def record_signal_strength(cycle)
      current_signal_strength = cycle * x_register
      signal_strengths << current_signal_strength
    end

    def perform_cpu_instruction(cpu_instruction)
      raise "Invalid command" unless cpu_instruction.starts_with?(ADD_X) || cpu_instruction == NO_OP

      return @cycles_waited += 1 if cpu_instruction.starts_with?(ADD_X) && cycles_waited.zero?

      if cpu_instruction.starts_with?(ADD_X)
        @cycles_waited = 0
        v = cpu_instruction.split.last.to_i
        @x_register += v
      end

      @cpu_instructions_position += 1
    end

    def part_two
      @x_register = 0
      crt = ["", "", "", "", "", ""]
      241.times do |cycle|
        next if cycle.zero?

        draw_pixel(cycle, crt)
        perform_cpu_instruction(cpu_instructions[cpu_instructions_position])
      end

      crt
    end

    def draw_pixel(cycle, crt)
      position = (cycle - 1) % 40
      crt_row = 0 if 1 <= cycle && cycle <= 40
      crt_row = 1 if 41 <= cycle && cycle <= 80
      crt_row = 2 if 81 <= cycle && cycle <= 120
      crt_row = 3 if 121 <= cycle && cycle <= 160
      crt_row = 4 if 161 <= cycle && cycle <= 200
      crt_row = 5 if 201 <= cycle && cycle <= 240

      if [x_register, x_register + 1, x_register + 2].include?(position)
        crt[crt_row] += "#"
      else
        crt[crt_row] += "."
      end
    end
  end
end
