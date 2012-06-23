require_relative '../lib/tmuxexecutor'
require_relative '../lib/tmuxrevive'

class TmuxExecutorM
  attr_accessor :title

  def window_title
    @title
  end
end

def tmux
  @tmux ||= TmuxExecutorM.new
end

Given /^a single tmux window with a title of "(.*?)"$/ do |title|
  tmux.title = title
end

When /^I trigger a session save$/ do
  @reviver = TmuxRevive.new tmux
  @reviver.save
end

Then /^the window title should be saved$/ do
  @reviver.saved_session( 0 ).window_title.should == tmux.title
end

