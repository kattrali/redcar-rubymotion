module Redcar
  class Cocoa
    class AppleScriptCommand < ProjectCommand
      def text
        "echo 'Hello World'"
      end

      def trace?
        !!Cocoa.storage['run_with_trace']
      end

      def suppress_trace?
        false
      end

      def execute
        if !!Cocoa.storage['save_project_before_running']
          win = Redcar.app.focussed_window
          win.notebooks.each do |notebook|
            notebook.tabs.each do |tab|
              if tab.is_a?(EditTab) and tab.edit_view.document.modified?
                tab.edit_view.document.save!
              end
            end
          end
        end
        command = commandline
        Thread.new do
          system("#{command}")
        end
      end

      def terminal_script(preferred, new_session=false)
        rakecmd = text
        rakecmd << " --trace" if trace? and not suppress_trace?
        if preferred.start_with? "iTerm"
          <<-OSASCRIPT
            tell the first terminal
              set isSet to "no"
              repeat with _session in sessions
                select _session
                tell _session
                  set theProcess to the first word of (name as text)
                  if theProcess = "RubyMotion" and isSet = "no"
                    set isSet to "yes"
                    write text "quit"
                  end if
                end tell
              end repeat
              if isSet = "no"
                launch session "Default Session"
              end
              tell the last session
                set name to "RubyMotion"
                write text "cd \\"#{project.path}\\";#{rakecmd}"
              end tell
            end tell
          OSASCRIPT
        else
          %{ do script "cd \\"#{project.path}\\";#{rakecmd}" }
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
      def scripts_path
        File.join(File.dirname(__FILE__), %[.. .. .. scripts])
      end

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
        if command = text
          Redcar::Runnables.run_process(project.path,command,title,output)
        end
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
        CompletionSource.clear_cache(project)
        "rake ctags"
      end

      def output
        "none"
      end
    end

    class StopSimulatorCommand < RunnablesCommand
      def text
        "osascript #{File.join(scripts_path,'stop-simulator.scpt')}"
      end

      def output
        "none"
      end
    end

    class TestFlightCommand < RunnablesCommand
      def text
        result = Redcar::Application::Dialog.input("Build Release Notes:")
        if result[:button] == :ok
          if text = result[:value]
            "rake testflight notes=\"#{text}\""
          else
            Redcar::Application::Dialog.message_box("Release Notes are required to release a build to TestFlight")
        end
      end

      def output
        "none"
      end
    end

    class HomeSimulatorCommand < RunnablesCommand
      def text
        "osascript #{File.join(scripts_path,'home-simulator.scpt')}"
      end

      def output
        "none"
      end
    end

    class QuitSimulatorCommand < RunnablesCommand
      def text
        "osascript #{File.join(scripts_path,'quit-simulator.scpt')}"
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