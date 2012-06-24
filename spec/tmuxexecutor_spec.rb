require_relative '../lib/tmuxexecutor'

describe TmuxExecutor do

  TYPICAL_TMUX_LIST_WINDOWS_OUTPUT = "1: test-title [151x41] [layout 44eb,151x41,0,0[151x28,0,0,151x12,0,29]] (active)"
  LAST_SESSION_ID = "4"
  TYPICAL_TMUX_LIST_SESSIONS_OUTPUT = "0: 2 windows (created Sun Jun 24 08:32:05 2012) [151x41] (attached)
#{LAST_SESSION_ID}: 1 windows (created Sun Jun 24 08:44:13 2012) [151x40]"

  let(:tmuxexecutor) { TmuxExecutor.new }

  it "extracts the window name from the output of tmux list-windows" do
    tmuxexecutor.should_receive(:'`').with('tmux list-windows') { TYPICAL_TMUX_LIST_WINDOWS_OUTPUT }

    tmuxexecutor.window_title.should == "test-title"
  end

  it "sets the window title" do
    tmuxexecutor.should_receive(:'`').with('tmux rename-window trevor')

    tmuxexecutor.set_window_title "trevor"
  end

  it "starts a new detached session and saves the session id" do
    tmuxexecutor.should_receive(:'`').with('OLD_TMUX=$TMUX; TMUX=""; tmux new-session -d ; TMUX=$OLD_TMUX')
    tmuxexecutor.should_receive(:'`').with('tmux list-sessions') { TYPICAL_TMUX_LIST_SESSIONS_OUTPUT }

    tmuxexecutor.start_tmux_session
    tmuxexecutor.session_id.should == LAST_SESSION_ID
  end

  it "if available uses session id to set window title"

end
