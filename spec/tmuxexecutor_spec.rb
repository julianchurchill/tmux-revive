require_relative '../lib/tmuxexecutor'

describe TmuxExecutor do
  TYPICAL_TMUX_LIST_WINDOWS_OUTPUT = "1: test-title [151x41] [layout 44eb,151x41,0,0[151x28,0,0,151x12,0,29]] (active)"
  LAST_SESSION_ID = "4"
  TYPICAL_TMUX_LIST_SESSIONS_OUTPUT = "0: 2 windows (created Sun Jun 24 08:32:05 2012) [151x41] (attached)
#{LAST_SESSION_ID}: 1 windows (created Sun Jun 24 08:44:13 2012) [151x40]"

  let(:tmuxexecutor) { TmuxExecutor.new }

  describe "#window_title" do
    it "extracts the window name from the output of tmux list-windows" do
      tmuxexecutor.should_receive(:'`').with('tmux list-windows') { TYPICAL_TMUX_LIST_WINDOWS_OUTPUT }

      tmuxexecutor.window_title.should == "test-title"
    end
  end

  describe "#set_window_title" do
    it "sets the window title" do
      tmuxexecutor.should_receive(:'`').with('tmux rename-window trevor')

      tmuxexecutor.set_window_title "trevor"
    end

    it "uses session id if available to set window title" do
      tmuxexecutor.should_receive(:'`').with('OLD_TMUX=$TMUX; TMUX=""; tmux new-session -d ; TMUX=$OLD_TMUX')
      tmuxexecutor.should_receive(:'`').with('tmux list-sessions') { TYPICAL_TMUX_LIST_SESSIONS_OUTPUT }
      tmuxexecutor.start_tmux_session

      tmuxexecutor.should_receive(:'`').with("tmux rename-window -t #{LAST_SESSION_ID} trevor")
      tmuxexecutor.set_window_title "trevor"
    end
  end

  describe "#start_tmux_session" do
    it "starts a new detached session and saves the session id" do
      tmuxexecutor.should_receive(:'`').with('OLD_TMUX=$TMUX; TMUX=""; tmux new-session -d ; TMUX=$OLD_TMUX')
      tmuxexecutor.should_receive(:'`').with('tmux list-sessions') { TYPICAL_TMUX_LIST_SESSIONS_OUTPUT }

      tmuxexecutor.start_tmux_session
      tmuxexecutor.session_id.should == LAST_SESSION_ID
    end
  end

  describe "#attach_session" do
    it "attaches to session using session id" do
      tmuxexecutor.should_receive(:'`').with('OLD_TMUX=$TMUX; TMUX=""; tmux new-session -d ; TMUX=$OLD_TMUX')
      tmuxexecutor.should_receive(:'`').with('tmux list-sessions') { TYPICAL_TMUX_LIST_SESSIONS_OUTPUT }
      tmuxexecutor.start_tmux_session

      tmuxexecutor.should_receive(:'`').with("OLD_TMUX=$TMUX; TMUX=\"\"; tmux attach -t #{LAST_SESSION_ID} ; TMUX=$OLD_TMUX")
      tmuxexecutor.attach_session
    end
  end
end
