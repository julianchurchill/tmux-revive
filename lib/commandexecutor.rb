class CommandExecutor

  def messages
    @messages ||= []
  end

  def puts message
    messages << message
  end

  def gets
    ""
  end

end

