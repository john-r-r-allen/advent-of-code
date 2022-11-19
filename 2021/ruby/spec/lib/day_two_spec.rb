require_relative "../../lib/advent_of_code/day_two"

RSpec.describe AdventOfCode::DayTwo do
  let(:indent) { "\t" }

  context "with the real puzzle input" do
    let(:subject) { described_class.new("../inputs/day_two.csv") }

    describe "#part_one" do
      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(1989265)
      end
    end

    describe "#part_two" do
      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(2089174012)
      end
    end
  end

  context "with the sample puzzle input" do
    let(:subject) { described_class.new("../inputs/sample_inputs/day_two.csv") }

    describe "#part_one" do
      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(150)
      end
    end

    describe "#part_two" do
      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(900)
      end
    end
  end
end
