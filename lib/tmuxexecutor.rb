class TmuxExecutor
  TMUX_LIST_WINDOWS_REGEX = /^\d+: (.*?) \[/

  def add_window_with_title title
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
end

