module Redcar
  class Cocoa
    class StartDebugger < RubyMotionProjectCommand
      def execute
        # check that debugger class exists
        begin
          GDI::Debugger::LLDB
        rescue
          Redcar::Application::Dialog.message_box(
            "Cocoa Debug",
            "The Redcar Debug plugin does not appear to be installed.")
          return
        end
        rakefile = File.join(project.path,'Rakefile')
        if appname_line = File.new(rakefile).lines.detect {|l| l =~ /app\.name\s*=\s*['"]/ }
          match = /app\.name\s*=\s*['"]([a-zA-Z0-9\-\s]+['"])/.match(appname_line)
          appname = match.captures.first
          GDI::ProcessController.new({:connection => "-n #{appname}",:model => GDI::Debugger::LLDB}).run
        else
          Redcar::Application::Dialog.message_box("Cocoa Debug", "A name for the current application was not found in the Rakefile. Perhaps the Rakefile needs updated?")
        end
      end
    end
  end
end