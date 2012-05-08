
module Redcar
  class Cocoa
    class AppleScriptCommand < ProjectCommand
      def text
        "echo 'Hello World'"
      end

      def execute
        if Cocoa.storage['save_project_before_running'] == true
          win = Redcar.app.focussed_window
          win.notebooks.each do |notebook|
            notebook.tabs.each do |tab|
              tab.edit_view.document.save! if tab.is_a?(EditTab) and tab.edit_view.document.modified?
            end
          end
        end
        command = commandline
        Thread.new do
          system("#{command}")
        end
      end

      def terminal_script(preferred, new_session=false)
        if preferred.start_with? "iTerm"
          <<-OSASCRIPT
            tell the first terminal
              launch session "Default Session"
              tell the last session
                set name to "RubyMotion"
                write text "cd \\"#{project.path}\\";#{text}"
              end tell
            end tell
          OSASCRIPT
        else
          %{ do script "cd \\"#{project.path}\\";#{text}" }
        end
      end

      def commandline
        preferred = (Project::Manager.storage['preferred_command_line'] ||= "Terminal")
        <<-BASH.gsub(/^\s*/, '')
          osascript <<END
            tell application "#{preferred}"
              #{terminal_script(preferred)}
              activate
            end tell
          END
        BASH
      end
    end

    class RunnablesCommand < ProjectCommand
      def text
        "echo 'hello world'"
      end

      def title
        "Run"
      end

      def output
        "tab"
      end

      def execute
        Redcar::Runnables.run_process(project.path,text,title,output)
      end
    end

    class BuildCommand < AppleScriptCommand
      def text
        "rake"
      end
    end

    class BuildAndCleanCommand < AppleScriptCommand
      def text
        "rake clean=1"
      end
    end

    class BuildOnDeviceCommand < AppleScriptCommand
      def text
        "rake device"
      end
    end

    class TestCommand < AppleScriptCommand
      def text
        "rake spec"
      end
    end

    class ArchiveCommand < AppleScriptCommand
      def text
        "rake archive"
      end
    end

    class ReleaseCommand < AppleScriptCommand
      def text
        "rake archive:release"
      end
    end

    class ConfigCommand < RunnablesCommand
      def text
        "rake config"
      end

      def title
        "Configuration"
      end
    end

    class GenerateTagsCommand < RunnablesCommand
      def text
        "rake ctags"
      end

      def output
        "none"
      end
    end

    class QuitSimCommand < RunnablesCommand
      def text
        path = File.join(File.dirname(File.expand_path(__FILE__)),'..','..','..','scripts')
        cmd  = "osascript #{File.join(path,'stop-simulation.scpt')} &&"
        preferred = (Project::Manager.storage['preferred_command_line'] ||= "Terminal")
        if preferred == "iTerm"
          cmd << "osascript #{File.join(path,'close-iterm-tab.scpt')};"
        end
        cmd
      end

      def output
        "none"
      end
    end

    class SendTicketCommand < RunnablesCommand
      def text
        "motion support"
      end

      def output
        "none"
      end
    end
  end
end