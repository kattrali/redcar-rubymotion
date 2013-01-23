require 'gdi/debug_annotation'
class GDI
  class Actions
    def self.set_breakpoint
      if edit_view = Redcar::EditView.current
        document = edit_view.document
        if document.mirror.is_a? Redcar::Project::FileMirror
          file = document.mirror.path
          line = document.cursor_line
          if debugger = GDI::Debugger.active_debugger_for_title(document.title)
             # indexing starts at 0 for document lines, but not for debuggers
            create_breakpoint_object(debugger, edit_view, file, line + 1)
          end
        end
      end
    end

    def self.toggle_breakpoint document, line
      if document.mirror.is_a? Redcar::Project::FileMirror
        file = document.mirror.path
        if debugger = GDI::Debugger.active_debugger_for_title(document.title)
          breakpoints = debugger.class.breakpoints.select do |b|
            b.file == file && b.line == line
          end

          if breakpoints.size > 0
            delete_breakpoint_object(debugger, document.edit_view, file, line)
          else
            create_breakpoint_object(debugger, document.edit_view, file, line)
          end
        end
      end
    end

    def self.delete_breakpoint
      if edit_view = Redcar::EditView.current
        document = edit_view.document
        if document.mirror.is_a? Redcar::Project::FileMirror
          file = document.mirror.path
          line = document.cursor_line + 1
          if debugger = GDI::Debugger.active_debugger_for_title(document.title)
            delete_breakpoint_object(debugger, edit_view, file, line)
          end
        end
      end
    end

    def self.evaluate
      document = Redcar.app.focussed_window.focussed_notebook.focussed_tab.document
      text = document.try(:selected_text)
      if text.any?
        responsible_debugger = GDI::Debugger.active_debuggers.detect {|d| document.title =~ d.src_extensions }
        if responsible_debugger
          responsible_debugger.process.input "#{responsible_debugger.class::Evaluate} #{text}"
        end
      end
    end

    private

    def self.delete_breakpoint_object debugger, edit_view, file, line
      breakpoints = debugger.class.breakpoints.reject! do |b|
        b.file == file && b.line == line
      end

      breakpoints.each { |b| debugger.try(:delete_breakpoint, b) }

      annotations = edit_view.annotations(:line => line)
      annotations.each do |a|
        edit_view.remove_annotation(a)
      end
    end

    def self.create_breakpoint_object debugger, edit_view, file, line
      DebugAnnotation.add(edit_view, line, :name => debugger.class.display_name, :scroll => true)
      breakpoint = debugger.class::Breakpoint.new.tap do |b|
        b.file = file
        b.line = line
        b.debugger = debugger.class
      end
      debugger.class.breakpoints << breakpoint
      debugger.try(:set_breakpoints)
    end
  end
end
