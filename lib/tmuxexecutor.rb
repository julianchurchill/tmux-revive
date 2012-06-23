class CommandLine

  def messages
    messages ||= []
  end

  def puts message
    @messages << message
  end

end

def command_line
  @command_line ||= CommandLine.new
end

class TmuxExecutor
  def initialize command_line
    @command_line = command_line
  end

  def add_window_with_title title
  end

  def window_title
    @command_line.puts "tmux window-name"
  end
end

