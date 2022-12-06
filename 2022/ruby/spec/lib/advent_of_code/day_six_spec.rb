RSpec.describe AdventOfCode::DaySix do
  let(:indent) { "\t" }
  let(:input_file_name) { "day_six.csv" }
  let(:sample_puzzle_input) { "../inputs/sample_inputs/#{input_file_name}" }
  let(:real_puzzle_input) { "../inputs/#{input_file_name}" }
  let(:subject) { described_class.new(sample_puzzle_input) }

  describe "#part_one" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new(real_puzzle_input) }

      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(1920)
      end
    end

    context "with the sample puzzle input" do
      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(7)
      end
    end
  end

  describe "#part_two" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new(real_puzzle_input) }

      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(2334)
      end
    end

    context "with the sample puzzle input" do
      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(19)
      end
    end
  end
end
