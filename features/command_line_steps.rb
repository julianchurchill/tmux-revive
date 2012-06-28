
Given /^a running tmux session with a window title of "(.*?)"$/ do |title|
  pending "start a tmux session we can run tmuxrevive within"
  # -d is detached, -n is window name
  #`tmux new-session -d -n #{title} \;`
  pending "how do we kill the real tmux session at the end of the scenario"
end

Then /^a new real tmux session should be started$/ do
  pending "check a real tmux session has been started"
  pending "how do we kill the real tmux session started by tmuxrevive in the successful case, at the end of the scenario"
end

Then /^the real tmux session window title should be "(.*?)"$/ do |title|
  pending "check the real tmux session title is correct"
end
