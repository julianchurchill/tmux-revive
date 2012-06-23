require_relative '../lib/tmuxexecutor'
require_relative '../lib/tmuxrevive'

class TmuxExecutorMock
  attr_accessor :window_title
  attr_reader :set_window_title_arg

  def set_window_title set_window_title_arg
    @set_window_title_arg = set_window_title_arg
  end
end

def tmux
  @tmux ||= TmuxExecutorMock.new
end

Given /^a single tmux window with a title of "(.*?)"$/ do |title|
  tmux.window_title = title
end

When /^I trigger a session save$/ do
  @reviver = TmuxRevive.new tmux
  @session = @reviver.save
end

Then /^the window title should be saved$/ do
  @session.window_title.should == tmux.window_title
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
  tmux.set_window_title_arg.should == @session.window_title
end

