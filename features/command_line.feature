Feature: tmuxrevive command line program
    In order to be able to use tmuxrevive features
    As a tmux user
    I want to run tmuxrevive to save and restore sessions

    Scenario: A session can be saved by one process and restored by a different one
        Given a tmux session with a window title of "pears"
            And I run `tmuxrevive save`
        When I run `tmuxrevive restore 1`
        Then a new tmux session should be started
            And the window title should be "pears"
