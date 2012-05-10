
module Redcar
  class Cocoa
    class TabHandler < Redcar::Snippets::TabHandler
      def self.priority
        # defer to regular snippets
        Redcar::Snippets::TabHandler.priority + 1
      end

      # Decides whether a snippet can be inserted at this location. If so
      # creates and returns the snippet, if not returns false.
      def self.find_snippet(edit_view)
        document = edit_view.document
        word = objc_method_before_cursor(edit_view)
        if word
          snippet = Autocompletion.method_to_snippet(word, word)
          activate_snippet(edit_view, snippet)
        end
      end

      # Scan the cursor line for an objective-c unexpanded
      # method and return it
      def self.objc_method_before_cursor(edit_view)
        document = edit_view.document
        line = document.get_slice(document.cursor_line_start_offset, document.cursor_offset)
        if Autocompletion.supported?(document) and Autocompletion.is_objc?(line, true)
          properties = Autocompletion.parse_objc(line, true)
          offset = document.cursor_line_start_offset + properties['bounds'].last
          if offset == document.cursor_offset
            properties['method']
          end
        end
      end
    end
  end
end