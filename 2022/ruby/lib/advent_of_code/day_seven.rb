module AdventOfCode
  class DaySeven
    ROOT_DIRECTORY = "/".freeze
    DIR_TYPE = "dir".freeze
    FILE_TYPE = "file".freeze
    CHANGE_DIRECTORY_COMMAND_START = "$ cd ".freeze
    LIST_DIRECTORY_COMMAND = "$ ls".freeze
    DIRECTORY_INITIALIZATION = { type: DIR_TYPE, contents: {} }.freeze
    PARENT_DIRECTORY = "..".freeze

    attr_reader :terminal_contents, :previous_directory, :current_directory, :directory_structure, :most_recent_command

    def initialize(puzzle_input_path)
      @terminal_contents = CSV.read(puzzle_input_path).map(&:first)
      @previous_directory = nil
      @current_directory = nil
      @directory_structure = { "/" => DIRECTORY_INITIALIZATION }
      @most_recent_command = nil
    end

    def part_one
      terminal_contents.each do |terminal_content|
        if terminal_content.starts_with?("$")
          process_command(terminal_content)
        else
          raise "receiving non commands before directory change" if current_directory.nil?

          process_current_directory_information(terminal_content)
        end
      end
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
      if command == CHANGE_DIRECTORY_COMMAND_START + ROOT_DIRECTORY && previous_directory.nil? && current_directory.nil?
        @previous_directory = ROOT_DIRECTORY
        @current_directory = ROOT_DIRECTORY
        return
      end

      if command[5..] == CHANGE_DIRECTORY_COMMAND_START + PARENT_DIRECTORY

      end
      @previous_directory = current_directory || command[5..]
      @current_directory = command[5..]
      return if current_directory == ROOT_DIRECTORY

      unless directory_structure[previous_directory].key?(current_directory)
        binding.pry
        raise "Changing to an unknown directory."
      end
    end

    def process_current_directory_information(terminal_content)
      return add_directory(terminal_content) if terminal_content.starts_with?("dir ")

      add_file(terminal_content)
    end

    def add_directory(terminal_content)
      directory = terminal_content[4..]
      unless directory_structure[current_directory][:contents].key?(directory)
        @directory_structure[current_directory][:contents][directory] = DIRECTORY_INITIALIZATION
      end
    end

    def add_file(terminal_content)
      find_size_and_name_space = terminal_content.index(" ")
      size = terminal_content[0..(find_size_and_name_space - 1)].to_i
      file_name = terminal_content[(find_size_and_name_space + 1)..]
      @directory_structure[current_directory]
    end

    def part_two
      nil
    end
  end
end


test = {
  "/" => {
    "a" => {
      "e" => {}
    }
  }
}
