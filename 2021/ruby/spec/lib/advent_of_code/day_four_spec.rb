require_relative "../../../lib/advent_of_code"

RSpec.describe AdventOfCode::DayFour do
  let(:indent) { "\t" }
  let(:input_file_name) { "day_four.csv" }

  context "with the real puzzle input" do
    let(:subject) { described_class.new("../inputs/#{input_file_name}") }

    describe "#part_one" do
      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(35670)
      end
    end

    describe "#part_two" do
      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(22704)
      end
    end
  end

  context "with the sample puzzle input" do
    let(:subject) { described_class.new("../inputs/sample_inputs/#{input_file_name}") }

    describe "#part_one" do
      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(4512)
      end
    end

    describe "#part_two" do
      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(1924)
      end
    end
  end
end
