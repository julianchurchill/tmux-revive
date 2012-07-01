
class TmuxRevive
  def save
    Dir.mkdir( "~/.tmuxrevive" )
    File.open( "~/.tmuxrevive/session.#{find_next_free_session_id}", 'w' ) { |f| f.write("") }
  end

  def find_next_free_session_id
    next_id = 1
    Dir.foreach( "~/.tmuxrevive" ) do |f|
      id = f[/^session\.(\d+)$/, 1].to_i
      next_id = id + 1 if id >= next_id
    end
    next_id
  end
end
