Feature: tmux session saving
    In order to be able to reboot my computer occassionally
    As a tmux user and computer programmer
    I want to be able to save my tmux session for later restoration

    Scenario: Single window saving
        Given a single tmux window with a single pane
        When I trigger a session save
        Then the window title should be saved
