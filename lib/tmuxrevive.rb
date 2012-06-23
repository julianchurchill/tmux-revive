require_relative 'tmuxsession'

class TmuxRevive

  def initialize tmux_command_line
    @tmux_command_line = tmux_command_line
  end

  def save
    s = TmuxSession.new
    s.window_title = @tmux_command_line.window_title
    s
  end

  def restore session
    @tmux_command_line.set_window_title session.window_title
  end

end
