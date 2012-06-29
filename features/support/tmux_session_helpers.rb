module TmuxSessionHelpers
  def get_last_tmux_session_id
    `tmux list-sessions`.split("\n").last[/^\d+/m]
  end

  def get_all_tmux_session_ids
    all_ids = []
    `tmux list-sessions`.split("\n").each do |session_line|
      all_ids += [session_line[/^\d+/]]
    end
    all_ids
  end
end
World(TmuxSessionHelpers)

