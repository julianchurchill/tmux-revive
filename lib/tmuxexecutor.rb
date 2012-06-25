class TmuxExecutor
  TMUX_LIST_WINDOWS_REGEX = /^\d+: (.*?) \[/
  TMUX_LIST_SESSIONS_REGEX = /^(\d+?):/m

  attr_reader :session_id

  def initialize
    @session_id = "-1"
  end

  def window_title
    output = `tmux list-windows`
    extract_window_title output
  end

  def extract_window_title input
    match = TMUX_LIST_WINDOWS_REGEX.match( input )
    return match[1] if match != nil
    ""
  end

  def set_window_title title
    session_id_arg = ""
    session_id_arg = "-t #{@session_id} " if session_id != -1
    `tmux rename-window #{session_id_arg}#{title}`
  end

  def start_tmux_session
    `OLD_TMUX=$TMUX; TMUX=""; tmux new-session -d ; TMUX=$OLD_TMUX`
    extract_last_session_id `tmux list-sessions`
  end

  def extract_last_session_id sessions_list
    matches = sessions_list.scan( TMUX_LIST_SESSIONS_REGEX ).flatten
    @session_id = matches.last if matches != nil
  end

  def attach_session
    `OLD_TMUX=$TMUX; TMUX=""; tmux attach -t #{@session_id} ; TMUX=$OLD_TMUX`
  end

end

