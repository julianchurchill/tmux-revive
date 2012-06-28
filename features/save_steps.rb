require_relative '../lib/tmuxexecutor'
require_relative '../lib/tmuxrevive'

class TmuxExecutorMock
  attr_accessor :window_title
  attr_reader :set_window_title_arg
  attr_reader :start_tmux_session_called
  attr_reader :attach_session_called

  def initialize
    @start_tmux_session_called = false
    @attach_session_called = false
  end

  def set_window_title set_window_title_arg
    @set_window_title_arg = set_window_title_arg
  end

  def start_tmux_session
    @start_tmux_session_called = true
  end

  def attach_session
    @attach_session_called = true
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

Given /^a saved tmux session with a window title of "(.*?)" and an ID of (.*?)$/ do |title,id|
  @session = TmuxSession.new
  @session.window_title = title
  @session.properties = { "id" => id }
  @all_sessions ||= {}
  @all_sessions[id] = @session
end

When /^I trigger a session restore$/ do
  @reviver = TmuxRevive.new tmux
  @reviver.restore @session
end

When /^I trigger a session restore of session (.*?)$/ do |id|
  @reviver = TmuxRevive.new tmux
  @reviver.restore @all_sessions[id]
end

Then /^the window title should be "(.*?)"$/ do |window_title|
  tmux.set_window_title_arg.should == window_title
end

Then /^the window title should be restored$/ do
  tmux.set_window_title_arg.should == @session.window_title
end

Given /^a saved tmux session$/ do
  @session = TmuxSession.new
end

Then /^a new tmux session should be started$/ do
  tmux.start_tmux_session_called.should == true
  tmux.attach_session_called.should == true
end

