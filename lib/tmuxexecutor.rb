require_relative 'commandexecutor'

class TmuxExecutor
  TMUX_LIST_WINDOWS_REGEX = /^\d+: (.*?) \[/

  def initialize command_line
    @command_line = command_line
  end

  def add_window_with_title title
  end

  def window_title
    @command_line.puts "tmux list-windows"
    extract_window_title @command_line.gets
  end

  def extract_window_title input
    TMUX_LIST_WINDOWS_REGEX.match( input )[1]
  end
end

