Redcar+RubyMotion
-----------------

Basic RubyMotion workflow support in Redcar Editor

![Screenshot](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/redcar-rubymotion.jpg)

## Features

- Build and Run project from Cocoa Menu
- Inline syntax checking for MacRuby

![Syntax Checking](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/syntax-checking.png)

- View reference documentation
- Send Support Tickets
- View Cocoa Framework class documentation from a shortcut
- Resource Manager pane for adding, removing, and viewing project resources
- CTags-based Autocompletion of class and method names (work in progress)

![Automcompletion](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/autocompletion.png)

## Requirements

- AppleScript, for terminal emulator interaction
- Redcar 0.12+
- RubyMotion 1.0+

## Installation

1. Close Redcar
2. Clone this repository into `~/.redcar/plugins/rubymotion`
3. `rm ~/.redcar/cache/textmate-bundles.cache`
4. Start Redcar

## Usage

Installing this plugin will add a new 'Cocoa' submenu to the Redcar menu bar. Syntax checking is performed on file save.

![Cocoa Menu](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/Menubar.png)

### Primary Commands

- **Run (⌘R):** Run default `rake` command; build app and launch simulator from a terminal window

- **Run on Device (Shift+⌘R):** Build app and launch in attached and configured iOS device

- **Test (^⌘T):** Run test suite
- **Quit iOS Simulator (Shift+^Q):** Close simulator
- **Create Archives:** Create release (App Store) and development .ipa files
- **Open Resource Manager:** Show project resources in a tree pane, organized by type
![Screenshot](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/resources.png)
- **Show Configuration:** Display `rake config` in a Web View
- **Show Class Documentation (Shift+⌘Space):** Open class documentation in a Web View for the class name currently under the cursor.
- **File Support Ticket:** File a ticket with RubyMotion support
- **Reference Links:** Open developer documentation in Web Views

## Configuration Notes

- To change which terminal emulator to use, set the `preferred_command_line` property in `project_plugin` preferences. I've only ever tried this with iTerm and Terminal, both seem to work fine.

- Automatically saving tabs before running a command can be disabled in `Cocoa` preferences by setting `save_project_before_running` to false.

- Reference Documentation can be opened in either the built-in Redcar browser or the external browser of choice by editing `use_external_browser_for_urls` in `html_view` preferences.

- By default, Redcar+RubyMotion interprets all Ruby files in RubyMotion projects using MacRuby syntax. Set `force_macruby_grammar` to `false` to disable this option.

- To change the path to the `ruby` executable, change `macruby_path` in `Cocoa` settings.

## Support

- Feel free to file an issue on github if you have a bug or suggestion. :)