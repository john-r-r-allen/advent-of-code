require_relative "../../../lib/advent_of_code"

RSpec.describe AdventOfCode::DayElevenPartTwo do
  let(:indent) { "\t" }
  let(:input_file_name) { "day_eleven.csv" }

  context "#part_two" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new(puzzle_input_path: "../inputs/#{input_file_name}", total_flashes: 0) }

      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(515)
      end
    end

    context "with the sample puzzle input" do
      let(:subject) do
        described_class.new(puzzle_input_path: "../inputs/sample_inputs/#{input_file_name}", total_flashes: 0)
      end

      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(195)
      end
    end
  end
end
