
require 'cocoa/tabs'
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
          item "Clean & Run", BuildAndCleanCommand
          item "Run on Device", BuildOnDeviceCommand
          item "Test", TestCommand
          separator
          item "Create Archives", ArchiveCommand
          item "Create Release", ReleaseCommand
          separator
          item "Show Configuration", ConfigCommand
          item "Show Class Documentation", ShowDocsCommand
          item "File Support Ticket", SendTicketCommand
          separator
          item "RubyMotion Reference Center", ShowRMDocs
          item "iOS API Reference", ShowIOSRefDocs
        end
      end
    end

    def self.keymaps
      osx = Redcar::Keymap.build("main", [:osx]) do
        link "Cmd+Shift+Space", ShowDocsCommand
        link "Cmd+R", BuildCommand
      end
      [osx]
    end

    def self.storage
      @storage ||= begin
        storage = Plugin::Storage.new('Cocoa')
        storage.set_default('save_project_before_running',true)
        storage
      end
    end
  end
end