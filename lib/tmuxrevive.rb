require_relative 'tmuxsession'

class TmuxRevive
  def save
  end

  def saved_session index
    TmuxSession.new
  end
end
