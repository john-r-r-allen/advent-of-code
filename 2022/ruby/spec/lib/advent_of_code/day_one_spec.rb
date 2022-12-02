RSpec.describe AdventOfCode::DayOne do
  let(:indent) { "\t" }
  let(:input_file_name) { "day_one.csv" }

  context "#part_one" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new("../inputs/#{input_file_name}") }

      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(71300)
      end
    end

    context "with the sample puzzle input" do
      let(:subject) { described_class.new("../inputs/sample_inputs/#{input_file_name}") }

      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(24000)
      end
    end
  end

  context "#part_two" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new("../inputs/#{input_file_name}") }

      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(209691)
      end
    end

    context "with the sample puzzle input" do
      let(:subject) { described_class.new("../inputs/sample_inputs/#{input_file_name}") }

      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(45000)
      end
    end
  end
end
