class CommandExecutor

  def messages
    messages ||= []
  end

  def puts message
    @messages << message
  end

end

