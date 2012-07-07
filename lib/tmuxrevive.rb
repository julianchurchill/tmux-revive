
class TmuxRevive
  SESSION_FILE = "session"

  def list
    print_session_info gather_info_for_each_session
  end

  def restore *args
    id = args.shift
    File.open( "#{tmuxrevive_dir}/#{SESSION_FILE}.#{id}", 'r' ) do |f|
      content = f.read
      window_title = content[/window_title (.*)$/, 1 ]
      `TMUX= tmux new-session -d -n #{window_title} \;`
    end
  end

  def save *args
    exit("save does not accept any arguments") unless args.empty?
    window_title = `tmux list-windows`[/^.*?: (.*?) \[/, 1]
    Dir.mkdir( "#{tmuxrevive_dir}" ) unless Dir.exists? tmuxrevive_dir
    File.open( "#{tmuxrevive_dir}/#{SESSION_FILE}.#{find_next_free_session_id}", 'w' ) { |f| f.write("window_title #{window_title}") }
  end

  private

  def gather_info_for_each_session
    all_session_info = []
    Dir.foreach( "#{tmuxrevive_dir}" ) do |entry|
      session_id = entry[/^.*\.(\d+)/,1]
      if session_id != nil
        session_info = "session #{session_id}:\n"
        File.open( "#{tmuxrevive_dir}/#{entry}" ) { |file| session_info += "    #{file.read}\n" }
        all_session_info += [ [ session_id, session_info ] ]
      end
    end
    all_session_info
  end

  def print_session_info all_session_info
    output = ""
    all_session_info.sort! { |a,b| a[0] <=> b[0] }
    all_session_info.each { |id,info| output += info }
    puts output
  end


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
