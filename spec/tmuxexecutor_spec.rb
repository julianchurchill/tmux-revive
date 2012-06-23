require_relative '../lib/tmuxexecutor'

describe TmuxExecutor do

  it "calls tmux window-name on the command line to get window name" do
    c = double( 'CommandLine' )
    c.should_receive( :puts ).with( 'tmux window-name' )
    t = TmuxExecutor.new c

    t.window_title
  end

end
