java_import org.eclipse.swt.widgets.ColorDialog

module Redcar
  class Cocoa

    # A command for launching a color picker dialog and
    # inserting a formatted color inline
    class OpenColorPicker < RubyMotionProjectCommand
      sensitize :edit_view_focussed

      STANDARD = "UIColor.colorWithRed(RED,green:GREEN,blue:BLUE,alpha:${1:1.0})"
      RGB_TYPE = "UIColor.rgb(RED,GREEN,BLUE)"
      HEX_TYPE = 'UIColor.hex("HEX")'

      def get_snippet
        parent = Redcar.app.focussed_window.controller.shell
        dialog = ColorDialog.new(parent)
        dialog.text = "Color Dialog"
        dialog.setRGB(Java::OrgEclipseSwtGraphics::RGB.new(red,green,blue))
        if color = dialog.open and snip = to_snippet(color)
          Redcar::Snippets::Snippet.new(nil,snip, :tab => 'color')
        end
      end

      def red
        @@red ||= 255
      end

      def green
        @@green ||= 255
      end

      def blue
        @@green ||= 255
      end

      # convert Swt::SWT:RGB object to decimal rgb
      def to_decimal color
        @@red, @@green, @@blue = color.red,color.green,color.blue
        [color.red,color.green,color.blue].map {|c| Integer((c.to_f/255)*100)/ Float(100) }
      end

      # convert Swt::SWT:RGB object to hex
      def to_hex color
        [color.red,color.green,color.blue].map {|c| c.to_s(16) }.join
      end

      #generate a Redcar::Snippets::Snippet from Swt::SWT::RGB
      def to_snippet color
        r, g, b = to_decimal(color).map {|d|d.to_s}
        hex  = to_hex(color)
        base = case Cocoa.storage['color_type']
        when 'standard' then STANDARD
        when 'hex' then HEX_TYPE
        when 'rgb' then RGB_TYPE
        when 'custom' then Cocoa.storage['custom_color_type']
        else
          STANDARD
        end
        if base
          # lol
          base.gsub('RED',r).gsub('GREEN',g).gsub('BLUE',b).gsub('HEX',hex)
        end
      end
    end
  end
end