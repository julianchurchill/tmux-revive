
Before do
  @session_ids_to_kill = Set.new
  @all_sessions = get_all_tmux_session_ids
end

After do
  @session_ids_to_kill.each do |id|
    `tmux kill-session -t #{id}`
  end
end

Given /^a running tmux session with a window title of "(.*?)"$/ do |title|
  # -d is detached, -n is window name
  `TMUX= tmux new-session -d -n #{title} \;`
  @session_ids_to_kill.add( get_last_tmux_session_id )
end

Then /^a new real tmux session should be started$/ do
  new_session_id = get_last_tmux_session_id
  @all_sessions.should_not include new_session_id
  @session_ids_to_kill.add( new_session_id )
end

Then /^the real tmux session window title should be "(.*?)"$/ do |title|
  real_window_title = get_window_name_for_session( get_last_tmux_session_id )
  real_window_title.should == title
end

def get_window_name_for_session id
  `tmux list-windows -t #{id}`[/^.*?: (.*?) \[/, 1]
end

