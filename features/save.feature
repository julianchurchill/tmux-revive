Feature: tmux session saving
    In order to be able to reboot my computer occassionally
    As a tmux user and computer programmer
    I want to be able to save my tmux session for later restoration

    Scenario: Single window saving
        Given a single tmux window with a title of "window title"
        When I trigger a session save
        Then the window title should be saved

    Scenario: Single window restore
        Given a saved tmux session with a window title of "window title"
        When I trigger a session restore
        Then the window title should be restored

    Scenario: On restore a new tmux session is created
        Given a saved tmux session
        When I trigger a session restore
        Then a new tmux session should be started

    Scenario: A session can be restored by ID
        Given a saved tmux session with a window title of "pears" and an ID of 1
            And a saved tmux session with a window title of "bananas" and an ID of 2
            And a saved tmux session with a window title of "apples" and an ID of 3
        When I trigger a session restore of session 2
        Then a new tmux session should be started
            And the window title should be "bananas"

    Scenario: A session can be saved by one process and restored by a different one
        Given a saved tmux session with a window title of "pears" and an ID of 1
        When I start a new tmuxrevive process
            And I trigger a session restore of session 1
        Then a new tmux session should be started
            And the window title should be "pears"
