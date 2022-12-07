module AdventOfCode
  class DaySeven
    ROOT_DIRECTORY = "/".freeze
    DIR_TYPE = "dir".freeze
    FILE_TYPE = "file".freeze
    CHANGE_DIRECTORY_COMMAND_START = "$ cd ".freeze
    LIST_DIRECTORY_COMMAND = "$ ls".freeze
    PARENT_DIRECTORY = "..".freeze

    attr_reader :terminal_contents,
                :most_recent_command,
                :root_node,
                :current_node

    def initialize(puzzle_input_path)
      @terminal_contents = CSV.read(puzzle_input_path).map(&:first)
      @most_recent_command = nil
      @root_node = Tree::TreeNode.new(ROOT_DIRECTORY, { type: DIR_TYPE } )
      @current_node = nil
      @directories_with_sizes = {}
    end

    def part_one
      terminal_contents.each do |terminal_content|
        if terminal_content.starts_with?("$")
          process_command(terminal_content)
        else
          raise "receiving non commands before directory change" if current_node.nil?
          raise "Not really sure what is going on." unless most_recent_command == LIST_DIRECTORY_COMMAND

          process_current_directory_information(terminal_content)
        end
      end

      determine_directory_sizes
      @directories_with_sizes.select { |_k,v| v <= 100_000 }.values.sum
    end

    def process_command(command)
      @most_recent_command = command
      return change_directory(command) if command.starts_with?(CHANGE_DIRECTORY_COMMAND_START)

      unless command == LIST_DIRECTORY_COMMAND
        binding.pry
        raise "Unexpected command"
      end
    end

    def change_directory(command)
      return @current_node = root_node if first_directory_change?(command)

      directory_name = command[5..]
      if command== CHANGE_DIRECTORY_COMMAND_START + PARENT_DIRECTORY
        raise "Attempting to navigate to the parent of the root directory" if current_node.root?

        @current_node = current_node.parent
      else
        current_node.children.each do |child|
          break @current_node = child if child.name == directory_name
        end
      end
    end

    def first_directory_change?(command)
      current_node.nil? && command == CHANGE_DIRECTORY_COMMAND_START + ROOT_DIRECTORY
    end

    def process_current_directory_information(terminal_content)
      return add_directory(terminal_content) if terminal_content.starts_with?("dir ")

      add_file(terminal_content)
    end

    def add_directory(terminal_content)
      directory = terminal_content[4..]

      @current_node << Tree::TreeNode.new(directory, { type: DIR_TYPE })
    end

    def add_file(terminal_content)
      find_size_and_name_space = terminal_content.index(" ")
      size = terminal_content[0..(find_size_and_name_space - 1)].to_i
      file_name = terminal_content[(find_size_and_name_space + 1)..]
      @current_node << Tree::TreeNode.new(file_name, { type: FILE_TYPE, size: size })
    end

    def determine_directory_sizes
      @directories_with_sizes[root_node.name] = determine_size_of_children(node: root_node, current_size: 0)
    end

    def determine_size_of_children(node:, current_size:)
      size = current_size

      node.children do |child|
        if child.content[:type] == DIR_TYPE
          size_of_child = determine_size_of_children(node: child, current_size: 0)
          unless @directories_with_sizes.key?(child.name)
            @directories_with_sizes[child.name] = size_of_child
          end
          size += size_of_child
        end
        size += child.content[:size] if child.content[:type] == FILE_TYPE
      end

      size
    end

    def part_two
      nil
    end
  end
end
