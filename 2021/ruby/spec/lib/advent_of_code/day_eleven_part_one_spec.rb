require_relative "../../../lib/advent_of_code"

RSpec.describe AdventOfCode::DayElevenPartOne do
  let(:indent) { "\t" }
  let(:input_file_name) { "day_eleven.csv" }

  context "#part_one" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new(total_flashes: 0, puzzle_input_path: "../inputs/#{input_file_name}") }

      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(1675)
      end
    end

    context "with the sample puzzle input" do
      let(:subject) do
        described_class.new(total_flashes: 0, puzzle_input_path: "../inputs/sample_inputs/#{input_file_name}")
      end

      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(1656)
      end
    end
  end
end
