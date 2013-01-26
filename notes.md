Release Notes
=============

### 0.9

- [Feature] Option to use inline documentation using [ClamShell](http://kattrali.github.com/clamshell/) and the [RubyMotion DocSet](http://rubymotion.com/files/RubyMotion.docset.zip)
- [Feature] Option to use inline documentation using RubyMotion RI -- work in progress, currently best supports class names


### 0.8

- [Feature] Added command for deploying a TestFlight build
- [Feature] Added links to TestFlight Dashboard and Provisioning Portal
- [Enhancement] Allow using template name as default file/class name
- [Fixed] Resolved typos in bundled file templates
- [Fixed] New resource directories are now added when adding new files

### 0.7

- [Feature] Added template engine for quick file generation
- [Enhancement] Maintain a single session for running commands in iTerm (with thanks to AaronH!)
- [Feature] Added option to run rake commands with `--trace`
- [Enhancement] Added "Build Options" to menu for easier access
- Reorganized the `Cocoa` menu

### 0.6.1

- [Feature] Added support for documentation lookup via [Dash](http://kapeli.com/dash/) app

### 0.6

- [Feature] Added speedy documentation lookup via [Ingredients](http://fileability.net/ingredients/) app

### 0.5

- [Feature] Autocompletion of Cocoa framework class names and methods
- [Feature] Added a few new snippets, remove Redcar bundle cache to update
- [Fixed] Resource pane failing to refresh when adding/removing files through other means
- [Fixed] 'Generate Tags' command failing to clear cached tags

### 0.4

- [Feature] Resource pane for managing the files to be included in app

### 0.3

- [Feature] MacRuby syntax checking

### 0.2

- [Enhancement] Try harder to determine correct Cocoa framework documentation path
- [Feature] More iTerm support; better handling for managing session proliferation

### 0.1

- [Feature] Run RubyMotion commands from 'Cocoa' menu
- [Feature] Look up UIKit documentation from menu or using shortcut when class name is under the cursor