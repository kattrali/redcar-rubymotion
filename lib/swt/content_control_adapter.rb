
module Redcar
  class Cocoa
    # org.eclipse.jface.fieldassist
    # Interface IControlContentAdapter
    class ContentControlAdapter
      attr_reader :doc

      def initialize document
        @doc = document
      end

      # Get the text contents of the control.
      def getControlContents control
        control.text
      end

      # Get the current cursor position in the control.
      def getCursorPosition control
        control.caretOffset
      end

      # Get the bounds (in pixels) of the insertion point for the control content.
      # This is a rectangle, in coordinates relative to the control, where the
      # insertion point is displayed. If the implementer does not have an insertion
      # point, or cannot determine the location of the insertion point, it is
      # appropriate to return the bounds of the entire control. This value may be
      # used to position a content proposal popup.
      def getInsertionBounds control
        prefix = doc.current_word
        offset = control.caretOffset - prefix.length
        point  = control.getLocationAtOffset(offset)
        height = control.lineHeight
        Java::OrgEclipseSwtGraphics::Rectangle.new(point.x, point.y, 0, height)
      end

      # Insert the specified contents into the control's current contents.
      # control - the control whose contents are to be altered.
      # contents - the String to be inserted into the control contents.
      # cursorPosition - the zero-based index representing the desired cursor
      #    position within the inserted contents after the insertion is made.
      def insertControlContents control, contents, cursorPosition
        prefix = doc.current_word
        offset = control.caretOffset - prefix.length

        next_line     = doc.offset_at_line(doc.cursor_line + 1)
        next_line_end = doc.offset_at_line_end(doc.cursor_line + 1)
        range         = doc.get_range(next_line, next_line_end - next_line)
        lagniappe     = range.strip.length > 0 ? 0 : range.length

        if Cocoa::Autocompletion.is_objc?(contents)
          control.replaceTextRange(offset, prefix.length + lagniappe, "")
          snippet    = Cocoa::Autocompletion.method_to_snippet(contents)
          controller = @doc.controllers(Redcar::Snippets::DocumentController).first
          controller.start_snippet!(snippet)
        else
          control.replaceTextRange(offset, prefix.length, contents)
        end
      end

      # Set the contents of the specified control to the specified text.
      # control - the control whose contents are to be set (replaced).
      # contents - the String specifying the new control content.
      # cursorPosition - the zero-based index representing the desired cursor
      #    position in the control's contents after the contents are set.
      def setControlContents control, string, cursorPosition
        control.text = string
        control.caretOffset = cursorPosition
      end

      # Set the current cursor position in the control.
      def setCursorPosition control, index
        control.caretOffset = index
      end
    end
  end
end