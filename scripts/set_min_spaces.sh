#!/usr/bin/osascript
on run argv
    if length of argv > 0 then
        set targetSpaceNumber to item 1 of argv as integer
    else
        set targetSpaceNumber to 10
    end if

    set spaceCount to (do shell script "defaults read com.apple.spaces | grep -c windows")
    set loopIterations to (targetSpaceNumber - spaceCount)

    if loopIterations = 0 then
        return "No new spaces added."
    end if

    do shell script "open -a 'Mission Control'"
    delay 0.5

    repeat loopIterations times
        delay 0.5
        tell application "System Events" to ¬
            click (every button whose value of attribute "AXDescription" is "add desktop") ¬
                of UI element "Spaces Bar" of UI element 1 of group 1 of process "Dock"
        delay 0.5
    end repeat

    do shell script "open -a 'Mission Control'"

    return loopIterations & " new spaces added."
end run
