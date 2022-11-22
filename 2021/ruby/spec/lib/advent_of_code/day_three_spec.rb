require_relative "../../../lib/advent_of_code"

RSpec.describe AdventOfCode::DayThree do
  let(:indent) { "\t" }

  context "with the real puzzle input" do
    let(:subject) { described_class.new("../inputs/day_three.csv") }

    describe "#part_one" do
      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(3374136)
      end
    end

    describe "#part_two" do
      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(4432698)
      end
    end
  end

  context "with the sample puzzle input" do
    let(:subject) { described_class.new("../inputs/sample_inputs/day_three.csv") }

    describe "#part_one" do
      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(198)
      end
    end

    describe "#part_two" do
      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(230)
      end
    end
  end
end
