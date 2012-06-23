require_relative '../lib/tmuxexecutor'

describe TmuxExecutor do

  TYPICAL_TMUX_LIST_WINDOWS_OUTPUT = "1: test-title [151x41] [layout 44eb,151x41,0,0[151x28,0,0,151x12,0,29]] (active)"

  it "parses the output of tmux list-windows to extract the window name" do
    c = double( 'CommandLine' )
    c.should_receive( :puts ).with( 'tmux list-windows' )
    c.should_receive( :gets ) { TYPICAL_TMUX_LIST_WINDOWS_OUTPUT }
    t = TmuxExecutor.new c

    t.window_title.should == "test-title"
  end

end
