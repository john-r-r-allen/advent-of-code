RSpec.describe AdventOfCode::DayNine do
  let(:indent) { "\t" }
  let(:input_file_name) { "day_nine.csv" }
  let(:sample_puzzle_input) { "../inputs/sample_inputs/#{input_file_name}" }
  let(:real_puzzle_input) { "../inputs/#{input_file_name}" }
  let(:subject) { described_class.new(sample_puzzle_input) }

  describe "#part_one" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new(real_puzzle_input) }

      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(5858)
      end
    end

    context "with the sample puzzle input" do
      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(13)
      end
    end
  end

  describe "#part_two" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new(real_puzzle_input) }

      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(2602)
      end
    end

    context "with the sample puzzle input" do
      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(1)
      end

      context "with the alternative sample puzzle input" do
        let(:subject) { described_class.new("../inputs/sample_inputs/day_nine_alternate.csv") }

        it "returns the expected result" do
          output = subject.part_two

          puts "#{indent}part two output: #{output}"
          expect(output).to eq(36)
        end
      end
    end
  end
end
