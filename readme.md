Redcar+RubyMotion
=================

Basic RubyMotion workflow support in Redcar Editor

### Features

- Build and Run project from Cocoa Menu
- View reference documentation
- Send Support Tickets
- View UIKit class documentation from a shortcut

### Installation

`cd ~/.redcar/plugins` and clone this directory

### Notes

- To change which terminal emulator to use, set the `preferred_command_line` property in `project_plugin` preferences. I've only ever tried this with iTerm and Terminal, both seem to work fine.

- Automatically saving tabs before running a command can be disabled in `Cocoa` preferences by setting `save_project_before_running` to false.

### To Do

- Add reasonable keybindings
- Make/Find a TextMate bundle for snippety goodness
- Add dialect-specific syntax checking