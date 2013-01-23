class GDI
  class Debugger
    class RubyMotion < Gdb
      Commandline = "rake debug=1 no_continue=1"
      Backtrace   = "backtrace"
      Locals      = "info locals"
      Breakpoints = "info breakpoints"
      Frame       = "info frame"
      Threads     = "info threads"
      Evaluate    = "print"
      Break       = "break"

      display_name "RubyMotion"
      src_extensions /\.rb$/
      file_linker Files::RubyMotionLinker
      auto_connecting!
      require_project!

      html_elements(
        {:partial => "repl"},
        {:partial => "notebook", :windows => [
          {:name => "Backtrace",   :id => "backtrace"},
          {:name => "Breakpoints", :id => "breakpoints"},
          {:name => "Threads",     :id => "threads"},
          {:name => "Locals",      :id => "locals"},
          {:name => "Frame",       :id => "frame"}]})

      supported_actions(
        {:icon => "control",         :title => "Continue", :command => "continue"},
        {:icon => "arrow-step-over", :title => "Next",     :command => "next"},
        {:icon => "control-power",   :title => "Quit",     :command => "quit"})

      def automatic_queries
        process.add_listener(:prompt_ready) do
          [:Backtrace, :Locals, :Breakpoints, :Threads, :Frame].each do |query|
            out = wait_for(self.class.const_get(query)) {|stdout| prompt_ready? stdout }
            output.replace(out, query.to_s.downcase)
          end
        end
      end
    end
  end
end