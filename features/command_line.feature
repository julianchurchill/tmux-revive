@announce
Feature: tmuxrevive command line program
    In order to be able to use tmuxrevive features
    As a tmux user
    I want to run tmuxrevive to save and restore sessions

    Scenario: A session can be saved to a file
        Given a directory named ".sessions"
        And a running tmux session with a window title of "pears"
        When I run `tmuxrevive save`
        Then a file named ".sessions/session.1" should exist
        And the file ".sessions/session.1" should contain "window_title pears"

    Scenario: A saved session can be restored from a file
        Given a directory named ".sessions"
        And a file named ".sessions/session.1" with:
            """
            window_title pears
            """
        When I run `tmuxrevive restore 1`
        Then a new real tmux session should be started
        And the real tmux session window title should be "pears"