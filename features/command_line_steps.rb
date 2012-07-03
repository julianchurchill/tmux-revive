
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
  @test_session_id = get_last_tmux_session_id
  send_command @test_session_id, "export HOME=#{ENV['HOME']}"
  send_command @test_session_id, "export PATH=#{ENV['PATH']}"
  @session_ids_to_kill.add( @test_session_id )
end

Given /^a session file named "(.*?)" with:$/ do |filename, content|
  steps "Given a file named \"#{File.expand_path( filename )}\" with:
    \"\"\"
    #{content}
    \"\"\""
end

When /^I run `tmuxrevive save` in the tmux session$/ do
  send_command @test_session_id, "tmuxrevive save"
  exit_session @test_session_id
  @session_ids_to_kill.delete( @test_session_id )
end

Then /^a session file named "(.*?)" should exist$/ do |filename|
  step "a file named \"#{File.expand_path( filename )}\" should exist"
end

Then /^the session file "(.*?)" should contain "(.*?)"$/ do |filename, content|
  step "the file \"#{File.expand_path( filename )}\" should contain \"#{content}\""
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

