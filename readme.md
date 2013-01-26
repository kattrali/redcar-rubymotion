Redcar+RubyMotion
-----------------

RubyMotion workflow support in Redcar Editor

![Screenshot](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/redcar-rubymotion.jpg)

## Features

- Build, Test, and Run app from Cocoa Menu
- Inline syntax checking for MacRuby
- Look up documentation for focussed text
- Send Support Tickets
- Generate classes from templates
- Save and Install custom templates
- View RubyMotion and iOS reference documentation
- Resource Manager pane for adding, removing, and viewing project resources
- [CTags-based Autocompletion](http://www.screencast.com/t/CGNWXexiRCvB) of class and method names -- Objective-C methods are automatically converted to Ruby!
- Release builds to beta testers using TestFlight

## Requirements

- AppleScript, for terminal emulator interaction
- Redcar 0.12+
- RubyMotion 1.0+
- (Optional) [ClamShell](http://kattrali.github.com/clamshell/), [Ingredients](http://fileability.net/ingredients/) or [Dash](http://kapeli.com/dash/), for documentation lookup

## Installation

### Fresh Install

1. Close Redcar
2. Clone this repository into `~/.redcar/plugins/rubymotion`
3. `rm ~/.redcar/cache/textmate-bundles.cache` (only necessary if you do not already have a MacRuby bundle installed in ~/.redcar/Bundles)
4. Start Redcar

### Upgrade

1. Close Redcar
2. Run `git fetch origin && git checkout 0.9` from `~/.redcar/plugins/rubymotion`
3. Start Redcar

## Usage

Installing this plugin will add a new 'Cocoa' submenu to the Redcar menu bar.

![Cocoa Menu](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/Menubar.png)

Syntax checking is performed on file save.

![Syntax Checking](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/syntax-checking.png)

### Primary Commands

- **Run (Cmd+R):** Run default `rake` command; build app and launch simulator from a terminal window

- **Run on Device (Shift+Cmd+R):** Build app and launch in attached and configured iOS device

- **Test (Ctrl+Cmd+T):** Run test suite
- **Quit iOS Simulator (Shift+Ctrl+Q):** Close simulator
- **Create Archives:** Create release (App Store) and development .ipa files
- **Open Resource Manager:** Show project resources in a tree pane, organized by type
![Screenshot](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/resources.png)
- **Show Configuration:** Display `rake config` in a Web View
- **Show Documentation (Shift+Cmd+Space):** Open documentation for selected or focussed text in [ClamShell](http://kattrali.github.com/clamshell/), [Ingredients](http://fileability.net/ingredients/), or [Dash](http://kapeli.com/dash/).
![Documentation Lookup](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/documentation-lookup.png)
- **File Support Ticket:** File a ticket with RubyMotion support
- **Reference Links:** Open developer documentation in Web Views
- **Menu Autocompletion:** Press `Shift+Ctrl+Space` or select Menu Auto Complete from the Edit menu

![Class Automcompletion](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/class-autocompletion.png)

![Method Automcompletion (before)](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/method-autocompletion-before.png)

![Method Automcompletion (after)](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/method-autocompletion-after.png)

## Customization

### Documentation Launcher

- The preferred app for searching documentation can be changed via the menu in `Cocoa > Documentation Launcher`.
- To change the path to Ingredients, Dash, or ClamShell apps, change `{app}_path` in `Cocoa` preferences.

![Inline Documentation](https://github.com/kattrali/redcar-rubymotion/raw/master/docs/clamshell-inline-docs.png)

### Terminal Emulator

- To change which terminal emulator to use, set the `preferred_command_line` property in `project_plugin` preferences. I've only ever tried this with iTerm2 and Terminal, both seem to work fine.

### Build Options

- **Saving Tabs Before Command Execution:** Automatically saving tabs before running a command can be changed via the menu in `Cocoa > Build Options`.
- **Running Rake Commands with `--trace`:** Automatically saving tabs before running a command can be changed via the menu in `Cocoa > Build Options`.

### Opening Links

- Reference Documentation can be opened in either the built-in Redcar browser or the external browser of choice by editing `use_external_browser_for_urls` in `html_view` preferences.

### Syntax Checking and Highlighting

- By default, Redcar+RubyMotion interprets all Ruby files in RubyMotion projects using MacRuby syntax. Set `force_macruby_grammar` in `Cocoa` preferences to `false` to disable this option.
- To change the path to the `ruby` implementation used for syntax checking, change `macruby_path` in `Cocoa` preferences.

### File Templates

- Custom File Templates can be installed in `~/.redcar/RubyMotion/templates`. All files must end in `snippet` and can optionally use TextMate snippet syntax for filling in fields. Any instances of `__NAME__` will replaced with the selected class name upon activation.

## Support

- Feel free to file an issue on github if you have a bug or suggestion. :)