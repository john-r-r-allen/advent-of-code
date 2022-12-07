module AdventOfCode
  class DaySeven
    ROOT_DIRECTORY = "/".freeze
    DIR_TYPE = "dir".freeze
    FILE_TYPE = "file".freeze
    CHANGE_DIRECTORY_COMMAND_START = "$ cd ".freeze
    LIST_DIRECTORY_COMMAND = "$ ls".freeze
    PARENT_DIRECTORY = "..".freeze
    TOTAL_DISK_SPACE = 70_000_000
    SPACE_NEEDED_FOR_UPDATE = 30_000_000

    attr_reader :terminal_contents,
                :most_recent_command,
                :root_node,
                :current_node,
                :directories_with_sizes

    def initialize(puzzle_input_path)
      @terminal_contents = CSV.read(puzzle_input_path).map(&:first)
      @most_recent_command = nil
      @root_node = Tree::TreeNode.new(ROOT_DIRECTORY, { type: DIR_TYPE })
      @current_node = nil
      @directories_with_sizes = {}
    end

    def part_one
      process_terminal_contents
      determine_directory_sizes
      directories_with_sizes.select { |_k, v| v <= 100_000 }.values.sum
    end

    def process_terminal_contents
      terminal_contents.each do |terminal_content|
        if terminal_content.starts_with?("$")
          process_command(terminal_content)
        else
          raise "receiving non commands before directory change" if current_node.nil?
          raise "Not really sure what is going on." unless most_recent_command == LIST_DIRECTORY_COMMAND

          process_current_directory_information(terminal_content)
        end
      end
    end

    def process_command(command)
      @most_recent_command = command
      return change_directory(command) if command.starts_with?(CHANGE_DIRECTORY_COMMAND_START)

      raise "Unexpected command" unless command == LIST_DIRECTORY_COMMAND
    end

    def change_directory(command)
      return @current_node = root_node if first_directory_change?(command)

      directory_name = command[5..]
      if command == CHANGE_DIRECTORY_COMMAND_START + PARENT_DIRECTORY
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
      @current_node << Tree::TreeNode.new(file_name, { type: FILE_TYPE, size: })
    end

    def determine_directory_sizes
      @directories_with_sizes[root_node.name] = determine_size_of_children(node: root_node, full_name: root_node.name)
    end

    def determine_size_of_children(node:, full_name:) # rubocop:disable Metrics/MethodLength
      size = 0

      node.children do |child|
        case child.content[:type]
        when DIR_TYPE
          size_of_child = determine_size_of_children(node: child, full_name: "#{full_name}#{child.name}/")
          raise "Unexpected code path followed." if @directories_with_sizes.key?("#{full_name}#{child.name}/")

          @directories_with_sizes["#{full_name}#{child.name}/"] = size_of_child
          size += size_of_child
        when FILE_TYPE
          size += child.content[:size]
        end
      end

      size
    end

    def part_two
      process_terminal_contents
      determine_directory_sizes
      unused_space = TOTAL_DISK_SPACE - directories_with_sizes[ROOT_DIRECTORY]
      needed_additional_space = SPACE_NEEDED_FOR_UPDATE - unused_space
      directories_with_sizes.select { |_dir, space| space >= needed_additional_space }.values.min
    end
  end
end
