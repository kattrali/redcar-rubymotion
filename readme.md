Redcar+RubyMotion
=================

Basic RubyMotion workflow support in Redcar Editor

![Screenshot](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/screenshot.png)

### Features

- Build and Run project from Cocoa Menu
- View reference documentation
- Send Support Tickets
- View Cocoa Framework class documentation from a shortcut

### Requirements

- AppleScript - for terminal emulator interaction
- Redcar
- `macruby` on the same path as Redcar, for syntax checking

### Installation

`cd ~/.redcar/plugins` and clone this directory

### Usage

Installing this plugin will add a new 'Cocoa' submenu to the Redcar menu bar. Syntax checking is performed on file save.

Primary Commands:

- *Run:* Run default `rake` command; build app and launch simulator from a terminal window

- *Run on Device:* Build app and launch in attached and configured iOS device

- *Test:* Run test suite

- *Stop iOS Simulator:* Close simulator

- *Create Archives:* Create release (App Store) and development .ipa files

- *Show Configuration:* Display `rake config` in a Web View

- *Show Class Documentation:* Open class documentation in a Web View for the class name currently under the cursor.

- *File Support Ticket:* File a ticket with RubyMotion support

- Reference Links: Open developer documentation in Web Views

### Configuration Notes

- To change which terminal emulator to use, set the `preferred_command_line` property in `project_plugin` preferences. I've only ever tried this with iTerm and Terminal, both seem to work fine.

- Automatically saving tabs before running a command can be disabled in `Cocoa` preferences by setting `save_project_before_running` to false.

- Reference Documentation can be opened in either the built-in Redcar browser or the external browser of choice by editing `use_external_browser_for_urls` in `html_view` preferences.

### To Do

- Add reasonable keybindings
- Add commands for testflight
- Create pane for viewing, adding, and removing resources
- Add preferences option to run rake commands with trace
- Add inline documentation for cocoapod dependencies