require_relative '../lib/tmuxrevive'
require_relative '../lib/tmuxexecutor'

describe TmuxRevive do

  it "calls tmux command line to find window title upon save" do
    tmux_command_line = double( "TmuxExecutor" )
    tmux_revive = TmuxRevive.new tmux_command_line

    tmux_revive.save

    tmux_command_line.should_receive( :window_title ) { "" }
  end

  it "stores current tmux window title upon save" do
    tmux_command_line = double( "TmuxExecutor" )
    tmux_command_line.stub( :window_title ) { "title" }
    tmux_revive = TmuxRevive.new tmux_command_line

    tmux_revive.save

    tmux_revive.saved_session( 0 ).window_title.should == "title"
  end

end
