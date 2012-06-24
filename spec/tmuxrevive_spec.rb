require_relative '../lib/tmuxrevive'
require_relative '../lib/tmuxexecutor'

describe TmuxRevive do

  let(:tmux_command_line) { double( "TmuxExecutor" ).as_null_object }
  let(:tmux_revive) { TmuxRevive.new tmux_command_line }

  it "stores current tmux window title upon save" do
    tmux_command_line.should_receive( :window_title ) { "title" }

    tmux_revive.save.window_title.should == "title"
  end

  it "restores tmux window title from session on restore" do
    tmux_command_line.should_receive( :start_tmux_session )

    tmux_revive.restore TmuxSession.new
  end

  it "restores tmux window title from session on restore" do
    session = TmuxSession.new
    session.window_title = "title"
    tmux_command_line.should_receive( :set_window_title ).with( "title" )

    tmux_revive.restore session
  end

end
