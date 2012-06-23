require_relative '../lib/tmuxexecutor'

describe TmuxExecutor do

  TYPICAL_TMUX_LIST_WINDOWS_OUTPUT = "1: test-title [151x41] [layout 44eb,151x41,0,0[151x28,0,0,151x12,0,29]] (active)"

  let(:tmuxexecutor) { TmuxExecutor.new }

  it "extracts the window name from the output of tmux list-windows" do
    tmuxexecutor.should_receive(:'`').with('tmux list-windows') { TYPICAL_TMUX_LIST_WINDOWS_OUTPUT }

    tmuxexecutor.window_title.should == "test-title"
  end

  it "sets the window title" do
    tmuxexecutor.should_receive(:'`').with('tmux rename-window trevor')

    tmuxexecutor.set_window_title "trevor"
  end

end
