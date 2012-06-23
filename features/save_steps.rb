require_relative '../lib/tmuxexecutor'
require_relative '../lib/tmuxrevive'

class TmuxExecutorMock
  attr_accessor :title

  def window_title
    @title
  end

  def set_window_title title
    @title = title
  end
end

def tmux
  @tmux ||= TmuxExecutorMock.new
end

Given /^a single tmux window with a title of "(.*?)"$/ do |title|
  tmux.title = title
end

When /^I trigger a session save$/ do
  @reviver = TmuxRevive.new tmux
  @session = @reviver.save
end

Then /^the window title should be saved$/ do
  @session.window_title.should == tmux.title
end

Given /^a saved tmux session with a window title of "(.*?)"$/ do |title|
  @session = TmuxSession.new
  @session.window_title = title
end

When /^I trigger a session restore$/ do
  @reviver = TmuxRevive.new tmux
  @reviver.restore @session
end

Then /^the window title should be restored$/ do
  tmux.window_title.should == @session.window_title
end

