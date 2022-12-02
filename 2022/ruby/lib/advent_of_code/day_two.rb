module AdventOfCode
  class DayTwo
    FIRST_COLUMN = {
      "A" => "rock",
      "B" => "paper",
      "C" => "scissors"
    }.freeze
    SECOND_COLUMN = {
      "X" => "rock",
      "Y" => "paper",
      "Z" => "scissors"
    }.freeze
    PLAY_SCORING = {
      "rock" => 1,
      "paper" => 2,
      "scissors" => 3
    }.freeze
    OUTCOMES = {
      "A" => {
        "X" => "draw",
        "Y" => "win",
        "Z" => "lose"
      },
      "B" => {
        "X" => "lose",
        "Y" => "draw",
        "Z" => "win"
      },
      "C" => {
        "X" => "win",
        "Y" => "lose",
        "Z" => "draw"
      },
    }.freeze
    OUTCOME_SCORING = {
      "lose" => 0,
      "draw" => 3,
      "win" => 6
    }.freeze

    attr_reader :encrypted_strategy_guide

    def initialize(puzzle_input_path)
      @encrypted_strategy_guide = CSV.read(puzzle_input_path).map(&:first).map(&:split)
    end

    def part_one
      score = 0
      encrypted_strategy_guide.each do |round|
        score += PLAY_SCORING[SECOND_COLUMN[round.last]] + OUTCOME_SCORING[OUTCOMES[round.first][round.last]]
      end
      score
    end

    def part_two
      nil
    end
  end
end
