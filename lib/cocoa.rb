
require 'cocoa/tabs'
require 'cocoa/syntax_checker'
require 'cocoa/commands/reference'
require 'cocoa/commands/scripting'

module Redcar
  class Cocoa

    def self.menus
      Menu::Builder.build do
        # sub_menu "File" do
        #   sub_menu "New...", :priority => 1 do
        #     item "RubyMotion App", CreateProjectCommand
        #   end
        # end
        sub_menu "Cocoa", :priority => 10 do
          item "Run", BuildCommand
          item "Clean and Run", BuildAndCleanCommand
          item "Run on Device", BuildOnDeviceCommand
          item "Test", TestCommand
          item "Close iOS Simulator", QuitSimCommand
          separator
          item "Create Archives", ArchiveCommand
          item "Create Release", ReleaseCommand
          separator
          item "Show Configuration", ConfigCommand
          item "Show Class Documentation", ShowDocsCommand
          item "File Support Ticket", SendTicketCommand
          separator
          item "RubyMotion Developer Center", ShowRMDocs
          item "iOS API Reference", ShowIOSRefDocs
        end
      end
    end

    def self.before_save document
      if document.path && win = Redcar.app.focussed_window and project = Project::Manager.in_window(win)
        confirmation = File.join(project.path,'.redcar','macruby.project')
        if File.exists? confirmation
          check_grammar(document)
        else
          rakefile = File.join(project.path,'Rakefile')
          if File.exists? rakefile
            text = File.new(rakefile).read
            if text.include?'motion/project'
              FileUtils.touch(confirmation)
              check_grammar(document)
            end
          end
        end
      end
    end

    def self.check_grammar document
      if document.edit_view.grammar.start_with? "Ruby"
        document.edit_view.grammar = "MacRuby" if storage['force_macruby_grammar']
      end
    end

    def self.keymaps
      osx = Redcar::Keymap.build("main", [:osx]) do
        link "Cmd+Shift+Space", ShowDocsCommand
        link "Cmd+R", BuildCommand
        link "Cmd+Shift+R", BuildOnDeviceCommand
        link "Cmd+Ctrl+T", TestCommand
        link "Ctrl+Shift+Q", QuitSimCommand
      end
      [osx]
    end

    def self.storage
      @storage ||= begin
        storage = Plugin::Storage.new('Cocoa')
        storage.set_default('macruby_path','/usr/local/bin/macruby')
        storage.set_default('encoding','utf-8')
        storage.set_default('force_macruby_grammar',true)
        storage.set_default('save_project_before_running',true)
        storage
      end
    end
  end
end