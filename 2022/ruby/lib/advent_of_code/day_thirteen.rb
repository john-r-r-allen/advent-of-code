module AdventOfCode
  class DayThirteen
    DECODER_PACKET_ONE = "[[2]]".freeze
    DECODER_PACKET_TWO = "[[6]]".freeze

    attr_reader :received_packets, :correct_packet_pairs

    def initialize(received_packets_path)
      @received_packets = File.read(received_packets_path).split("\n")
      @correct_packet_pairs = []
      @switches = 0
    end

    def received_packet_pairs
      @received_packet_pairs ||= ((received_packets.size - 2) / 3) + 1
    end

    def part_one
      received_packet_pairs.times do |pair_index|
        pair_number = pair_index + 1
        first_index = pair_index * 3
        second_index = first_index + 1
        left_side = Side.new(received_packets[first_index])
        right_side = Side.new(received_packets[second_index])

        if left_side.less_than?(right_side)
          puts "Pair #{pair_number} in correct order".green
          @correct_packet_pairs << pair_number
        end
      end
      correct_packet_pairs.sum
    end

    def part_two
      received_packets.reject!(&:empty?)
      @received_packets.append(DECODER_PACKET_ONE, DECODER_PACKET_TWO)
      sortable_packets = received_packets.map { |packet| Side.new(packet) }
      sortable_packets.sort!
      # TODO: The sort here is putting the second decoder packet in the wrong position. It needs to be moved one back.
      packet_one_position = sortable_packets.find_index { |packet| packet.data.to_s == DECODER_PACKET_ONE } + 1
      packet_two_position = sortable_packets.find_index { |packet| packet.data.to_s == DECODER_PACKET_TWO } + 1
      packet_one_position * packet_two_position
    end
  end
end

class Side
  FIRST_SMALLER = 0
  ITEMS_EQUAL = 1
  SECOND_SMALLER = 2

  attr_reader :data

  def initialize(input)
    @data = interpret(input)
  end

  def interpret(input)
    JSON.parse(input)
  rescue StandardError => e
    binding.pry
  end

  def less_than?(other_side)
    puts "Comparing #{data} to #{other_side.data}"
    data.each_with_index do |value, index|
      item_test = item_smaller?(first: value, second: other_side.data[index])
      return true if item_test == FIRST_SMALLER
      return false if item_test == SECOND_SMALLER

    rescue StandardError => e
      CustomLogger.call(
        action: "side.less_than?.failure",
        message: "Failed on index #{index}",
        error: e,
        data: [data, other_side.data]
      )
      raise e
    end

    true
  end

  def item_smaller?(first:, second:, indents: 1)
    if first.is_a?(Array) && second.is_a?(Array)
      return SECOND_SMALLER if !first.empty? && second.empty?
      first.size.times do |index|
        result = item_smaller?(first: first[index], second: second[index], indents: indents + 1)
        return result unless result == ITEMS_EQUAL
      end
      return FIRST_SMALLER if first.size < second.size
      return ITEMS_EQUAL
    end
    return item_smaller?(first: first, second: [] << second, indents: indents + 1) if first.is_a?(Array)
    return item_smaller?(first: [] << first, second: second, indents: indents + 1) if second.is_a?(Array)
    return FIRST_SMALLER if first.nil?
    return SECOND_SMALLER if second.nil?


    indentation = "\t" * indents
    comparison =  "Compare #{first} vs #{second} "

    if first == second
      result = ITEMS_EQUAL
      puts indentation + comparison + "(Items Equal)"
    elsif first < second
      result = FIRST_SMALLER
      puts indentation + comparison + "(First Smaller)"
    else
      result = SECOND_SMALLER
      puts indentation + comparison + "(Second Smaller)"
    end
    result
  end
  def <=>(other)
    less_than?(other) ? -1 : 1
  end
end

module CustomLogger
  module_function

  def call(action:, message:, error: nil, data: [])
    puts "Action #{action}".light_blue
    puts "Message: #{message}".light_blue
    data.each_with_index { |value, index| puts "Data item #{index + 1}: #{value.to_json}".light_blue }
    puts "Error Message: \n\t#{error.message}".light_blue unless error.nil?
  end
end
