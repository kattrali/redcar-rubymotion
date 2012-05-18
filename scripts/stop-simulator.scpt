tell application "iTerm"
  tell the first terminal
    set isSet to "no"
    repeat with _session in sessions
      select _session
      tell _session
        set theProcess to the first word of (name as text)
        if theProcess = "RubyMotion" and isSet = "no"
          set isSet to "yes"
          write text "quit"
        end if
      end tell
    end repeat
  end tell
end tell