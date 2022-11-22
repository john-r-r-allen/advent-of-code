require_relative "../../../lib/advent_of_code"

RSpec.describe AdventOfCode::DayOne do
  let(:indent) { "\t" }

  context "with the real puzzle input" do
    let(:subject) { described_class.new("../inputs/day_one.csv") }

    describe "#part_one" do
      it "returns the expected number of increases" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(1709)
      end
    end

    describe "#part_two" do
      it "returns the expected number of increases" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(1761)
      end
    end
  end

  context "with the sample puzzle input" do
    let(:subject) { described_class.new("../inputs/sample_inputs/day_one.csv") }

    describe "#part_one" do
      it "returns the expected number of increases" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(7)
      end
    end

    describe "#part_two" do
      it "returns the expected number of increases" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(5)
      end
    end
  end
end
