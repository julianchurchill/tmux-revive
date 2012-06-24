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

