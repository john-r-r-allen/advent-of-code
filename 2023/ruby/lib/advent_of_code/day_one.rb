module AdventOfCode
  class DayOne
    attr_reader :calibration_document

    def initialize(puzzle_inputh_path)
      @calibration_document = CSV.read(puzzle_inputh_path).map(&:first)
    end

    def part_one
      total = 0;
      calibration_document.each do |calibration_document_line|
        
      end
    end
  end
end
