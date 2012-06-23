require_relative '../lib/tmuxexecutor'
require_relative '../lib/tmuxrevive'

Given /^a single tmux window with a title of "(.*?)"$/ do |title|
  tmux = TmuxExecutor.new
  @title = title
  tmux.add_window_with_title @title
end

When /^I trigger a session save$/ do
  @reviver = TmuxRevive.new
  @reviver.save
end

Then /^the window title should be saved$/ do
  @reviver.saved_session( 0 ).window_title.should == @title
end

