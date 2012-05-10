module Redcar
  class AutoCompleter
    class ListDialog

      def selected(index)
        if text = select(index)
          offset = @doc.cursor_offset - @prefix.length
          if Cocoa::Autocompletion.supported?(@doc) and Cocoa::Autocompletion.is_objc?(text)
            @doc.replace(offset, @prefix.length, "")
            snippet    = Cocoa::Autocompletion.method_to_snippet(text)
            controller = @doc.controllers(Redcar::Snippets::DocumentController).first
            controller.start_snippet!(snippet)
          else
            @doc.replace(offset, @prefix.length, text)
          end
          close
        end
      end
    end
  end
end
