
Before do
  @test_session_id = nil
end

After do
  `tmux kill-session -t #{@test_session_id}` if @test_session_id
end

Given /^a running tmux session with a window title of "(.*?)"$/ do |title|
  # -d is detached, -n is window name
  `tmux new-session -d -n #{title} \;`
  @test_session_id = get_last_tmux_session_id
end

Then /^a new real tmux session should be started$/ do
  pending "check a real tmux session has been started"
  pending "how do we kill the real tmux session started by tmuxrevive in the successful case, at the end of the scenario"
end

Then /^the real tmux session window title should be "(.*?)"$/ do |title|
  pending "check the real tmux session title is correct"
end
