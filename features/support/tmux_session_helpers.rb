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

  def get_window_name_for_session id
    `tmux list-windows -t #{id}`[/^.*?: (.*?) \[/, 1]
  end

  def exit_session id
    send_command id, "exit"
    `TMUX= tmux attach -t #{id} \;`
  end

  def send_command id, keys
    `tmux send-keys -t #{id} \"#{keys}\"\;`
    `tmux send-keys -t #{id} Enter \;`
  end

end
World(TmuxSessionHelpers)

