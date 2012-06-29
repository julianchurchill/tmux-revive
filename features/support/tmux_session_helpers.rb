module TmuxSessionHelpers
  def get_last_tmux_session_id
    `tmux list-sessions`.split("\n").last[/^\d+/m]
  end
end
World(TmuxSessionHelpers)

