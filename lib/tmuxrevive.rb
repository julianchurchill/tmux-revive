
class TmuxRevive
  def save
    Dir.mkdir( "~/.tmuxrevive" )
    File.open( "~/.tmuxrevive/session.1", 'w' ) { |f| f.write("") }
  end
end
