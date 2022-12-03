RSpec.describe AdventOfCode::DayThree do
  let(:indent) { "\t" }
  let(:input_file_name) { "day_three.csv" }

  fcontext "#item_priority" do
    let(:subject) { described_class.new("../inputs/sample_inputs/#{input_file_name}") }

    it "returns 1-26 for a-z (1 for a, 2 for b,... 26 for z)" do
      expect(subject.item_priority("a")).to eq(1)
      expect(subject.item_priority("b")).to eq(2)
      expect(subject.item_priority("z")).to eq(26)
    end

    it "returns 27-52 for A-Z (27 for A, 28 for B,... 52 for Z)" do
      expect(subject.item_priority("A")).to eq(27)
      expect(subject.item_priority("B")).to eq(28)
      expect(subject.item_priority("Z")).to eq(52)
    end
  end

  context "#part_one" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new("../inputs/#{input_file_name}") }

      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(12740)
      end
    end

    context "with the sample puzzle input" do
      let(:subject) { described_class.new("../inputs/sample_inputs/#{input_file_name}") }

      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(15)
      end
    end
  end

  context "#part_two" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new("../inputs/#{input_file_name}") }

      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(11980)
      end
    end

    context "with the sample puzzle input" do
      let(:subject) { described_class.new("../inputs/sample_inputs/#{input_file_name}") }

      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output).to eq(12)
      end
    end
  end
end
