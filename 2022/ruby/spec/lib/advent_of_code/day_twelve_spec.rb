RSpec.describe AdventOfCode::DayTwelve do
  let(:indent) { "\t" }
  let(:input_file_name) { "day_twelve.csv" }
  let(:sample_puzzle_input) { "../inputs/sample_inputs/#{input_file_name}" }
  let(:real_puzzle_input) { "../inputs/#{input_file_name}" }
  let(:subject) { described_class.new(sample_puzzle_input) }

  describe "#part_one" do
    # context "with the real puzzle input" do
    #   let(:subject) { described_class.new(real_puzzle_input) }
    #
    #   it "returns the expected result" do
    #     output = subject.part_one
    #
    #     puts "#{indent}part one output: #{output}"
    #     expect(output).to eq(408)
    #   end
    # end

    context "with the sample puzzle input" do
      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(31)
      end
    end
  end

  describe "#part_two" do
    # context "with the real puzzle input" do
    #   let(:subject) { described_class.new(real_puzzle_input) }
    #
    #   it "returns the expected result" do
    #     output = subject.part_two
    #
    #     puts "#{indent}part two output: #{output}"
    #     expect(output).to eq(399)
    #   end
    # end

    context "with the sample puzzle input" do
      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(29)
      end
    end
  end
end
