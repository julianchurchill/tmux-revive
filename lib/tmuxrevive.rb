
class TmuxRevive
  def initialize
    @last_id = 1
  end

  def save
    Dir.mkdir( "~/.tmuxrevive" )
    File.open( "~/.tmuxrevive/session.#{@last_id}", 'w' ) { |f| f.write("") }
    @last_id += 1
  end
end
