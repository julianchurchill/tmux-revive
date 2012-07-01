
class TmuxRevive
  SESSION_FILE = "session"

  def save
    window_title = `tmux list-windows`[/^.*?: (.*?) \[/, 1]
    Dir.mkdir( "#{tmuxrevive_dir}" ) unless Dir.exists? tmuxrevive_dir
    File.open( "#{tmuxrevive_dir}/#{SESSION_FILE}.#{find_next_free_session_id}", 'w' ) { |f| f.write("window_title #{window_title}") }
  end

  private

  def find_next_free_session_id
    next_id = 1
    Dir.foreach( "#{tmuxrevive_dir}" ) do |f|
      id = f[/^#{SESSION_FILE}\.(\d+)$/, 1].to_i
      next_id = id + 1 if id >= next_id
    end
    next_id
  end

  def tmuxrevive_dir
    ENV['HOME'] + "/.tmuxrevive"
  end
end
