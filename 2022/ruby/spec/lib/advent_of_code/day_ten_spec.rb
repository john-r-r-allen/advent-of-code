RSpec.describe AdventOfCode::DayTen do
  let(:indent) { "\t" }
  let(:input_file_name) { "day_ten.csv" }
  let(:sample_puzzle_input) { "../inputs/sample_inputs/#{input_file_name}" }
  let(:real_puzzle_input) { "../inputs/#{input_file_name}" }
  let(:subject) { described_class.new(sample_puzzle_input) }

  describe "#part_one" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new(real_puzzle_input) }

      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(13720)
      end
    end

    context "with the sample puzzle input" do
      it "returns the expected result" do
        output = subject.part_one

        puts "#{indent}part one output: #{output}"
        expect(output).to eq(13140)
      end
    end
  end

  describe "#part_two" do
    context "with the real puzzle input" do
      let(:subject) { described_class.new(real_puzzle_input) }

      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output[0]).to eq("####.###..#..#.###..#..#.####..##..#..#.")
        expect(output[1]).to eq("#....#..#.#..#.#..#.#..#....#.#..#.#..#.")
        expect(output[2]).to eq("###..###..#..#.#..#.####...#..#....####.")
        expect(output[3]).to eq("#....#..#.#..#.###..#..#..#...#....#..#.")
        expect(output[4]).to eq("#....#..#.#..#.#.#..#..#.#....#..#.#..#.")
        expect(output[5]).to eq("#....###...##..#..#.#..#.####..##..#..#.")

      end
    end

    context "with the sample puzzle input" do
      it "returns the expected result" do
        output = subject.part_two

        puts "#{indent}part two output: #{output}"
        expect(output[0]).to eq("##..##..##..##..##..##..##..##..##..##..")
        expect(output[1]).to eq("###...###...###...###...###...###...###.")
        expect(output[2]).to eq("####....####....####....####....####....")
        expect(output[3]).to eq("#####.....#####.....#####.....#####.....")
        expect(output[4]).to eq("######......######......######......####")
        expect(output[5]).to eq("#######.......#######.......#######.....")
      end
    end
  end

  context "#check_signal_strength?" do
    context "when cycle 20, 60, 100, 140, 180, or 220" do
      it "returns true" do
        expect(subject.check_signal_strength?(20)).to eq(true)
        expect(subject.check_signal_strength?(60)).to be true
        expect(subject.check_signal_strength?(100)).to be true
        expect(subject.check_signal_strength?(140)).to be true
        expect(subject.check_signal_strength?(180)).to be true
        expect(subject.check_signal_strength?(220)).to be true
      end
    end

    context "when not cycle 20, 60, 100, 140, 180, or 220" do
      it "returns false" do
        222.times do |i|
          next if [20, 60, 100, 140, 180, 220].include?(i)

          expect(subject.check_signal_strength?(i)).to be false
        end
      end
    end
  end
end
