
require 'cocoa/tabs'
require 'cocoa/syntax_checker'
require 'cocoa/autocompletion'
require 'cocoa/autocompletion/completion_source'
require 'cocoa/autocompletion/tab_handler'
require 'cocoa/autocompletion/list_dialog'
require 'cocoa/resources/tree_controller'
require 'cocoa/resources/tree_nodes'
require 'cocoa/resources/tree_mirror'
require 'cocoa/commands/command'
require 'cocoa/commands/reference'
require 'cocoa/commands/scripting'
require 'cocoa/commands/tree_commands'
require 'cocoa/commands/templates'

module Redcar
  class Cocoa

    def self.sensitivities
      [
        Sensitivity.new(:open_rubymotion_project, Redcar.app, false, [:focussed_window]) do
          if win = Redcar.app.focussed_window and project = Project::Manager.in_window(win)
            Cocoa.is_rubymotion? project
          end
        end
      ]
    end

    def self.menus
      Menu::Builder.build do
        sub_menu "File" do
          lazy_sub_menu "New...", :priority => -20 do
            # item "RubyMotion App", CreateProjectCommand
            Cocoa.templates.each do |path|
              item File.basename(path).sub(".snippet","") do
                CreateFromTemplateCommand.new(path).run
              end
            end
          end
          group :priority => 1 do
            item "Save As Template...", SaveFileAsTemplateCommand
          end
        end
        sub_menu "Cocoa", :priority => 10 do
          item "Run", BuildCommand
          item "Clean and Run", BuildAndCleanCommand
          item "Run on Device", BuildOnDeviceCommand
          item "Test", TestCommand
          sub_menu "Simulator" do
            item "Stop", StopSimulatorCommand
            item "Quit", QuitSimulatorCommand
            item "Home", HomeSimulatorCommand
          end
          lazy_sub_menu "Build Options" do
            item "Run rake commands with --trace", :type => :check, :checked => !!Cocoa.storage['run_with_trace'] do
              Cocoa.storage['run_with_trace'] = !Cocoa.storage['run_with_trace']
            end
            # item "Use MacRuby syntax", :type => :check, :checked => !!Cocoa.storage['force_macruby_grammar'] do
            #   Cocoa.storage['force_macruby_grammar'] = !Cocoa.storage['force_macruby_grammar']
            # end
            item "Save open files before each run", :type => :check, :checked => !!Cocoa.storage['save_project_before_running'] do
              Cocoa.storage['save_project_before_running'] = !Cocoa.storage['save_project_before_running']
            end
          end
          separator
          sub_menu "Documentation" do
            item "Show Documentation for Text", DocsLookupCommand
            separator
            item "Documentation Launcher", Redcar::Top::ShowTitle
            DocsLookupCommand.supported_apps.each do |app|
              item app, :type => :radio, :checked => Cocoa.storage['documentation_launcher'] == app do
                Cocoa.storage['documentation_launcher'] = app
              end
            end
          end
          separator
          sub_menu "Release" do
            item "Upload TestFlight Build", TestFlightCommand
            item "Create Development Archive", ArchiveCommand
            item "Create Release Archive", ReleaseCommand
          end
          separator
          item "Open Resources Manager", OpenResourcesTree
          item "Show Configuration", ConfigCommand
          item "Generate Tags", GenerateTagsCommand
          separator
          item "RubyMotion Developer Center", ShowRMDocs
          item "iOS API Reference", ShowIOSRefDocs
          item "TestFlight Dashboard", ShowTestflightDashboard
          item "iOS Provisioning Portal", ShowProvisioningPortal
          separator
          item "File Support Ticket", SendTicketCommand
        end
      end
    end

    def self.user_template_path
      File.join(Redcar.user_dir, %w[RubyMotion templates])
    end

    def self.template_paths
      [
        File.join(File.dirname(__FILE__), %w[.. templates]),
        user_template_path
      ]
    end

    def self.templates
      Dir.glob(Cocoa.template_paths.map {|p| "#{p}/*.snippet"})
    end

    def self.before_save document
      if document.path && win = Redcar.app.focussed_window and project = Project::Manager.in_window(win)
        if is_rubymotion? project
          check_grammar(document)
        end
      end
    end

    def self.is_rubymotion? project
      confirmation = File.join(project.path,'.redcar','macruby.project')
      if File.exists? confirmation
        return true
      else
        rakefile = File.join(project.path,'Rakefile')
        if File.exists? rakefile
          text = File.new(rakefile).read
          if text.include?'motion/project'
            FileUtils.touch(confirmation)
            return true
          end
        end
      end
      return false
    end

    def self.tab_handlers
      [Cocoa::TabHandler]
    end
    def self.autocompletion_source_types
      [Cocoa::CompletionSource]
    end

    def self.check_grammar document
      if document.edit_view.grammar.start_with? "Ruby"
        document.edit_view.grammar = "MacRuby" if storage['force_macruby_grammar']
      end
    end

    def self.keymaps
      osx = Redcar::Keymap.build("main", [:osx]) do
        link "Cmd+Shift+Space", DocsLookupCommand
        link "Cmd+R", BuildCommand
        link "Cmd+Shift+R", BuildOnDeviceCommand
        link "Cmd+Ctrl+T", TestCommand
        link "Ctrl+Shift+Q", QuitSimulatorCommand
        link "Ctrl+Shift+S", StopSimulatorCommand
        link "Ctrl+Shift+H", HomeSimulatorCommand
      end
      [osx]
    end

    def self.storage
      @storage ||= begin
        storage = Plugin::Storage.new('Cocoa')
        storage.set_default('macruby_path','/Library/RubyMotion/bin/ruby')
        storage.set_default('encoding','utf-8')
        storage.set_default('force_macruby_grammar',true)
        storage.set_default('dash_path','/Applications/Dash.app')
        storage.set_default('ingredients_path','/Applications/Ingredients.app')
        storage.set_default('clamshell_path','/Applications/ClamShell.app')
        storage.set_default('save_project_before_running',true)
        storage.set_default('documentation_launcher','Ingredients')
        storage.set_default('run_with_trace',false)
        storage
      end
    end
  end
end
