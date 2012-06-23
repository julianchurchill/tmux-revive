require_relative '../lib/tmuxexecutor'

describe TmuxExecutor do

  TYPICAL_TMUX_LIST_WINDOWS_OUTPUT = "1: test-title [151x41] [layout 44eb,151x41,0,0[151x28,0,0,151x12,0,29]] (active)"

  it "extracts the window name from the output of tmux list-windows" do
    t = TmuxExecutor.new
    t.should_receive(:'`').with('tmux list-windows') { TYPICAL_TMUX_LIST_WINDOWS_OUTPUT }

    t.window_title.should == "test-title"
  end

end
