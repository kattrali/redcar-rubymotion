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

      def execute
        parent = Redcar.app.focussed_window.controller.shell
        dialog = ColorDialog.new(parent)
        dialog.text = "Color Dialog"
        dialog.setRGB(Swt::SWT::RGB.new(255,255,255))
        if color = dialog.open and snip = to_snippet(color)
          text = Redcar::Snippets::Snippet.new(snip)
          controller = doc.controllers(Snippets::DocumentController).first
          controller.start_snippet!(text)
        end
      end

      # convert Swt::SWT:RGB object to decimal rgb
      def to_decimal color
        [color.red,color.green,color.blue].map {|c| c.to_f/255 }
      end

      # convert Swt::SWT:RGB object to hex
      def to_hex color
        [color.red,color.green,color.blue].map {|c| c.to_s(16) }.join
      end

      #generate a Redcar::Snippets::Snippet from Swt::SWT::RGB
      def to_snippet color
        red, green, blue = to_decimal(color)
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
          base.gsub('RED',red).gsub('GREEN',green).gsub('BLUE',blue).gsub('HEX',hex)
        end
      end
    end
  end
end