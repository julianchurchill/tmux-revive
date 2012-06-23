require_relative '../lib/tmuxrevive'
require_relative '../lib/tmuxexecutor'

describe TmuxRevive do
  before do
    @tmux_command_line = double( "TmuxExecutor" )
    @tmux_revive = TmuxRevive.new @tmux_command_line
  end

  it "stores current tmux window title upon save" do
    @tmux_command_line.should_receive( :window_title ) { "title" }

    @tmux_revive.save.window_title.should == "title"
  end

  it "restores tmux window title from session on restore" do
    session = TmuxSession.new
    session.window_title = "title"
    @tmux_command_line.should_receive( :set_window_title ).with( "title" )

    @tmux_revive.restore session
  end

end
