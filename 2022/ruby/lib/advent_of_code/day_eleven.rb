module AdventOfCode
  class DayEleven
    MONKEY_NOTES_INTRODUCED_MONKEY_START = "Monkey".freeze
    MONKEY_NOTES_ITEMS_START = "  Starting items:".freeze
    MONKEY_NOTES_OPERATION_START = "  Operation: new = old ".freeze
    MONKEY_NOTES_TEST_START = "  Test: divisible by ".freeze
    MONKEY_NOTES_TRUE_TEST_START = "    If true: throw to monkey ".freeze
    MONKEY_NOTES_FALSE_TEST_START = "    If false: throw to monkey ".freeze
    MULTIPLICATION = "*".freeze
    ADDITION = "+".freeze

    attr_reader :monkey_notes, :monkeys, :current_monkey

    def initialize(monkey_notes_path)
      @monkey_notes = File.read(monkey_notes_path).split("\n")
      @monkeys = []
      @current_monkey = nil
      interpret_data
    end

    def interpret_data # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      @monkey_notes.each do |monkey_note|
        next if monkey_note.blank?

        process_new_monkey(monkey_note) if monkey_note.starts_with?(MONKEY_NOTES_INTRODUCED_MONKEY_START)
        process_starting_items(monkey_note) if monkey_note.starts_with?(MONKEY_NOTES_ITEMS_START)
        process_operation(monkey_note) if monkey_note.starts_with?(MONKEY_NOTES_OPERATION_START)
        process_test(monkey_note) if monkey_note.starts_with?(MONKEY_NOTES_TEST_START)
        process_true_test(monkey_note) if monkey_note.starts_with?(MONKEY_NOTES_TRUE_TEST_START)
        process_false_test(monkey_note) if monkey_note.starts_with?(MONKEY_NOTES_FALSE_TEST_START)
      end
      set_test_monkey_throws
    end

    def process_new_monkey(monkey_note)
      @current_monkey = Monkey.new(monkey_note.split.last.delete(",").to_i)
      @monkeys << current_monkey
    end

    def process_starting_items(monkey_note)
      items = monkey_note.split(" ").map { |item| item.delete(",").to_i }[2..]
      current_monkey.items = items
    end

    def process_operation(monkey_note)
      current_monkey.operation = monkey_note[MONKEY_NOTES_OPERATION_START.size..].split(" ")
    end

    def process_test(monkey_note)
      current_monkey.test_divisible_by = monkey_note[MONKEY_NOTES_TEST_START.size..].to_i
    end

    def process_true_test(monkey_note)
      current_monkey.true_test_throw_number = monkey_note[MONKEY_NOTES_TRUE_TEST_START.size..].to_i
    end

    def process_false_test(monkey_note)
      current_monkey.false_test_throw_number = monkey_note[MONKEY_NOTES_FALSE_TEST_START.size..].to_i
    end

    def set_test_monkey_throws
      monkeys.each do |monkey|
        monkey.true_test_throw = monkeys[monkey.true_test_throw_number]
        monkey.false_test_throw = monkeys[monkey.false_test_throw_number]
      end
    end

    def part_one
      20.times { check_items_for_monkeys(part: "one") }
      monkeys.map(&:item_inspection_count).sort.last(2).inject(:*)
    end

    def part_one_worry_reduction(item)
      item / 3
    end

    def common_factor
      @common_factor ||= monkeys.map(&:test_divisible_by).inject(:*)
    end

    def part_two
      10_000.times { check_items_for_monkeys(part: "two") }
      monkeys.map(&:item_inspection_count).sort.last(2).inject(:*)
    end

    def check_items_for_monkeys(part:) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      raise "Invalid part passed to check_items_for_monkeys" unless %w(one two).include?(part)

      monkeys.each do |monkey|
        monkey.items.each do |item|
          monkey.increment_item_inspection_count
          item = apply_monkey_operation(monkey, item)
          item = public_send("part_#{part}_worry_reduction", item)
          if monkey.test?(item)
            monkey.true_test_throw.items << item
          else
            monkey.false_test_throw.items << item
          end
        end
        monkey.items = []
      end
    end

    def apply_monkey_operation(monkey, item) # rubocop:disable Metrics/AbcSize
      case monkey.operation[:operator]
      when MULTIPLICATION
        return item * item if monkey.operation[:term] == "old"

        item * monkey.operation[:term]
      when ADDITION
        return item + item if monkey.operation[:term] == "old"

        item + monkey.operation[:term]
      else
        raise "Unexpected opearator of #{monkey.operation[:operator]}"
      end
    end

    def part_two_worry_reduction(item)
      item % common_factor # Reduces the item number without changing how it will interact with the monkey's tests
    end
  end
end

class Monkey
  attr_reader :id,
              :test_divisible_by,
              :true_test_throw,
              :false_test_throw,
              :operation,
              :true_test_throw_number,
              :false_test_throw_number,
              :item_inspection_count
  attr_accessor :items

  def initialize(monkey_number)
    @id = monkey_number
    @items = []
    @operation = nil
    @test_divisible_by = nil
    @true_test_throw = nil
    @false_test_throw = nil
    @true_test_throw_number = nil
    @false_test_throw_number = nil
    @item_inspection_count = 0
  end

  def test?(number)
    (number % test_divisible_by).zero?
  end

  def increment_item_inspection_count
    @item_inspection_count += 1
  end

  def operation=(operation_data)
    raise "Attempting to set operation again" unless operation.nil?

    operator = operation_data.first
    term = operation_data.last
    term = term.to_i unless term == "old"
    @operation = { operator:, term: }
  end

  def test_divisible_by=(number)
    raise "Attempting to set test_divisible_by again" unless test_divisible_by.nil?

    @test_divisible_by = number
  end

  def true_test_throw_number=(monkey_number)
    raise "Attempting to set true_test_throw again" unless true_test_throw.nil?

    @true_test_throw_number = monkey_number
  end

  def false_test_throw_number=(monkey_number)
    raise "Attempting to set false_test_throw again" unless false_test_throw.nil?

    @false_test_throw_number = monkey_number
  end

  def true_test_throw=(monkey)
    raise "Attempting to set true_test_throw again" unless true_test_throw.nil?
    raise "Must throw to another Monkey" unless monkey.instance_of?(Monkey)

    @true_test_throw = monkey
  end

  def false_test_throw=(monkey)
    raise "Attempting to set false_test_throw again" unless false_test_throw.nil?
    raise "Must throw to another Monkey" unless monkey.instance_of?(Monkey)

    @false_test_throw = monkey
  end
end
