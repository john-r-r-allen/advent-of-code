module AdventOfCode
  class DayTwelve
    attr_reader :heightmap, :paths_to_finish, :debugging
    delegate :data,
             :nodes,
             :start_position,
             :end_position,
             :up_position,
             :down_position,
             :right_position,
             :left_position,
             :able_to_move?,
             to: :heightmap

    def initialize(heightmap_path)
      @heightmap = HeightMap.new(heightmap_path)
      @paths_to_finish = []
    end

    def part_one
      graph = Graph.new
      nodes.each do |node|
        neighbors(node).each do |neighbor|
          graph.add_edge(node, neighbor)
        end
      end
      graph.shortest_path(start_position, end_position)[:distance]
    end

    def neighbors(original_node)
      available_neighbors = []

      available_neighbors << right_neighbor(original_node)
      available_neighbors << left_neighbor(original_node)
      available_neighbors << up_neighbor(original_node)
      available_neighbors << down_neighbor(original_node)

      available_neighbors.compact!
      available_neighbors.select do |neighbor|
        able_to_move?(current_position: original_node, desired_position: neighbor)
      end
    end

    def right_neighbor(original_node)
      nodes.select { |node| node == right_position(original_node) }.first
    end

    def left_neighbor(original_node)
      nodes.select { |node| node == left_position(original_node) }.first
    end

    def up_neighbor(original_node)
      nodes.select { |node| node == up_position(original_node) }.first
    end

    def down_neighbor(original_node)
      nodes.select { |node| node == down_position(original_node) }.first
    end

    def part_two
      nil
    end
  end
end

class HeightMap
  STARTING_POINT_MARKER = "S".freeze
  BEST_SIGNAL_POINT_MARKER = "E".freeze
  ELEVATION_ORDERING = "abcdefghijklmnopqrstuvwxyz".freeze

  attr_reader :data, :nodes

  def initialize(heightmap_path)
    @data = CSV.read(heightmap_path).map(&:first).reverse.map(&:chars)
    nodes_from_data
  end

  def nodes_from_data
    @nodes = []

    data.each_with_index do |row, row_index|
      row.each_with_index do |_height, column_index|
        @nodes << { row: row_index, column: column_index }
      end
    end

    @nodes
  end

  def print_heightmap
    row_outputs = []
    row_outputs << "=" * 193
    data.each_with_index do |row, row_index|
      row_output = ""
      row.each_with_index do |height, column_index|
        row_output += "|\t(#{row_index}, #{column_index}) #{height}\t"
      end
      row_output += "|"
      row_outputs << row_output
    end
    row_outputs << "=" * 193
    row_outputs.reverse.each { |row_output| puts row_output }
  end

  def start_position
    return @start_position if defined?(@start_position)

    @start_position = {}
    data.each_with_index do |row, row_index|
      next if row.index(STARTING_POINT_MARKER).nil?

      @start_position[:row] = row_index
      @start_position[:column] = row.index(STARTING_POINT_MARKER)
      break
    end

    @start_position
  end

  def end_position
    return @end_position if defined?(@end_position)

    @end_position = {}
    data.each_with_index do |row, row_index|
      next if row.index(BEST_SIGNAL_POINT_MARKER).nil?

      @end_position[:row] = row_index
      @end_position[:column] = row.index(BEST_SIGNAL_POINT_MARKER)
      break
    end

    @end_position
  end

  def elevation(position)
    elevation_character = data.dig(position[:row])&.dig(position[:column])
    raise "Invalid position provided to elevation" if elevation_character.nil?
    return 0 if elevation_character == "S"
    return 25 if elevation_character == "E"

    ELEVATION_ORDERING.index(elevation_character)
  end

  def max_row_index
    data.size - 1
  end

  def max_column_index
    data.first.size - 1
  end

  def down_position(current_position)
    { row: current_position[:row] - 1, column: current_position[:column] }
  end

  def up_position(current_position)
    { row: current_position[:row] + 1, column: current_position[:column] }
  end

  def right_position(current_position)
    { row: current_position[:row], column: current_position[:column] + 1 }
  end

  def left_position(current_position)
    { row: current_position[:row], column: current_position[:column] - 1 }
  end

  def able_to_move?(current_position:, desired_position:)
    height_difference = elevation(desired_position) - elevation(current_position)

    height_difference < 2
  end
end

require 'set'

class Graph
  attr_reader :graph, :nodes, :previous, :distance
  INFINITY = 1 << 64

  def initialize
    @graph = {} # the graph // {node => { edge1 => weight, edge2 => weight}, node2 => ...
    @nodes = Set.new
  end

  def connect_graph(source, target, weight = 1)
    if graph.has_key?(source)
      graph[source][target] = weight
    else
      graph[source] = {target => weight}
    end
    nodes << source
  end

  # connect each node bidirectional
  def add_edge(source, target, weight = 1)
    connect_graph(source, target, weight) #directional graph
  end

  def dijkstra(source)
    @distance={}
    @previous={}
    nodes.each do |node| # initialization
      @distance[node] = INFINITY # Unknown distance from source to vertex
      @previous[node] = -1 # Previous node in optimal path from source
    end

    @distance[source] = 0 # Distance from source to source

    queue = Set.new
    queue << source

    until queue.empty?
      u = queue.min_by { |n| @distance[n] }

      break if (@distance[u] == INFINITY)

      queue.delete(u)

      graph[u].keys.each do |vertex|
        alt = @distance[u] + graph[u][vertex]
        next if alt >= @distance[vertex]

        @distance[vertex] = alt
        @previous[vertex] = u # A shorter path to vertex has been found
        queue << vertex
      end
    end
  end

  def find_path(dest)
    find_path(@previous[dest]) if @previous[dest] != -1

    @path ||= []
    @path << dest
  end

  def shortest_path(starting_position, ending_position)
    @source = starting_position
    dijkstra(starting_position)
    # nodes.each do |dest|
    @path=[]

    find_path ending_position

    actual_distance =
      if @distance[ending_position] != INFINITY
        @distance[ending_position]
      else
        "no path"
      end


    { path: @path.join("-->"), distance: actual_distance }
  end

  def shortest_paths(starting_position)
    @graph_paths={}
    @source = starting_position
    dijkstra(starting_position)
    nodes.each do |dest|
      @path=[]

      find_path dest

      actual_distance =
        if @distance[dest] != INFINITY
          @distance[dest]
        else
          "no path"
        end
      @graph_paths[dest] = { path: @path.join("-->"), distance: actual_distance }
    end
    @graph_paths
  end

  def print_result
    @graph_paths.each do |graph|
      puts graph
    end
  end
end
