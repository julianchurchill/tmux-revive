require_relative 'tmuxsession'

class TmuxRevive

  def initialize tmux_command_line
    @tmux_command_line = tmux_command_line
  end

  def save
    @window_title = @tmux_command_line.window_title
  end

  def saved_session index
    s = TmuxSession.new
    s.window_title = @window_title
    s
  end

end
