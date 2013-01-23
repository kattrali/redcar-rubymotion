
module Redcar
  class Cocoa
    class AnnotationListener

      def initialize document
        @doc = document
      end

      def mouseClick line_number
        GDI::Actions.toggle_breakpoint(@doc, line_number)
      end

      def mouseDoubleClick line_number
      end
    end
  end
end