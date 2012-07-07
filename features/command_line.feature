@announce
Feature: tmuxrevive command line program
    In order to be able to use tmuxrevive features
    As a tmux user
    I want to run tmuxrevive to save and restore sessions

    Scenario: A session can be saved to a file
        Given a running tmux session with a window title of "pears"
        When I run `tmuxrevive save` in the tmux session
        Then a session file named "~/.tmuxrevive/session.1" should exist
        And the session file "~/.tmuxrevive/session.1" should contain "window_title pears"

    Scenario: A saved session can be restored from a file
        Given a session file named "~/.tmuxrevive/session.1" with:
            """
            window_title apples
            """
        When I run `tmuxrevive restore 1`
        Then a new real tmux session should be started
        And the real tmux session window title should be "apples"

    Scenario: Multiple sessions have been saved and I want a list
        Given a session file named "~/.tmuxrevive/session.1" with:
            """
            window_title apples
            """
            And a session file named "~/.tmuxrevive/session.2" with:
            """
            window_title oranges
            """
            And a session file named "~/.tmuxrevive/session.3" with:
            """
            window_title papaya
            """
        When I run `tmuxrevive list`
        Then the output should contain exactly:
            """
            session 1:
                window_title apples
            session 2:
                window_title oranges
            session 3:
                window_title papaya

            """
