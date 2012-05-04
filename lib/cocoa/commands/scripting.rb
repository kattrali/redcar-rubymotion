
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
        Thread.new do
          system("#{commandline}")
        end
      end

      def terminal_script(preferred, new_session=false)
        if preferred.start_with? "iTerm"
          <<-OSASCRIPT
            tell the first terminal
              # launch session "Default Session"
              tell the last session
                write text "#{text}"
              end tell
            end tell
          OSASCRIPT
        else
          %{ do script "#{text}" }
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

    class ConfigCommand < AppleScriptCommand
      def text
        "rake config"
      end
    end

    class QuitSimCommand < AppleScriptCommand
      def text
        "quit"
      end
    end

    class SendTicketCommand < ProjectCommand
      def execute
        path = project.path
        Redcar::Runnables.run_process(project.path,"motion support","Support","none")
      end
    end
  end
end