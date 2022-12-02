module AdventOfCode
  class DayTwo
    SECOND_COLUMN_PART_ONE = {
      "X" => "rock",
      "Y" => "paper",
      "Z" => "scissors"
    }.freeze
    PLAY_SCORING = {
      "rock" => 1,
      "paper" => 2,
      "scissors" => 3
    }.freeze
    OUTCOMES_PART_ONE = {
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
      }
    }.freeze
    OUTCOMES_PART_TWO = {
      "X" => "lose",
      "Y" => "draw",
      "Z" => "win"
    }.freeze
    OUTCOME_SCORING = {
      "lose" => 0,
      "draw" => 3,
      "win" => 6
    }.freeze
    PLAY_LOOKUP_PART_TWO = {
      "A" => {
        "win" => "paper",
        "draw" => "rock",
        "lose" => "scissors"
      },
      "B" => {
        "win" => "scissors",
        "draw" => "paper",
        "lose" => "rock"
      },
      "C" => {
        "win" => "rock",
        "draw" => "scissors",
        "lose" => "paper"
      }
    }.freeze

    attr_reader :encrypted_strategy_guide

    def initialize(puzzle_input_path)
      @encrypted_strategy_guide = CSV.read(puzzle_input_path).map(&:first).map(&:split)
    end

    def part_one
      part_one_play_score + part_one_outcome_score
    end

    def part_one_play_score
      @part_one_play_score ||= encrypted_strategy_guide.map do |round|
        play_score(SECOND_COLUMN_PART_ONE[round.last])
      end.sum
    end

    def part_one_outcome_score
      @part_one_outcome_score ||= encrypted_strategy_guide.map do |round|
        outcome_score(OUTCOMES_PART_ONE[round.first][round.last])
      end.sum
    end

    def part_two
      part_two_outcome_score + part_two_play_score
    end

    def part_two_outcome_score
      @part_two_outcome_score ||= encrypted_strategy_guide.map do |round|
        outcome_score(OUTCOMES_PART_TWO[round.last])
      end.sum
    end

    def part_two_play_score
      @part_two_play_score ||= encrypted_strategy_guide.map do |round|
        play_score(
          determine_play_for_outcome(opponent_play: round.first, outcome: OUTCOMES_PART_TWO[round.last])
        )
      end.sum
    end

    def play_score(play)
      PLAY_SCORING[play]
    end

    def outcome_score(outcome)
      OUTCOME_SCORING[outcome]
    end

    def determine_play_for_outcome(opponent_play:, outcome:)
      PLAY_LOOKUP_PART_TWO[opponent_play][outcome]
    end
  end
end
