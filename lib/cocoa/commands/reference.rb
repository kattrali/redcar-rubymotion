module Redcar
  class Cocoa
    class URLCommand < ProjectCommand
      def title;"Google";end
      def url
        "www.google.com"
      end
      def execute
        if text = url and not text.empty?
          Redcar::HtmlView::DisplayWebContent.new(title,url,true,Cocoa::ReferenceTab).run
        end
      end
      def message text
        Redcar::Application::Dialog.message_box(text,"Reference Documentation")
      end
    end

    class ShowProvisioningPortal < URLCommand
      def title;"Provisioning Portal";end
      def url
        "https://developer.apple.com/ios/manage/provisioningprofiles/"
      end
    end

    class ShowTestflightDashboard < URLCommand
      def title;"TestFlight";end
      def url
        "https://testflightapp.com/dashboard/"
      end
    end

    class ShowRMDocs < URLCommand
      def title;"RubyMotion";end
      def url
        "www.rubymotion.com/developer-center/"
      end
    end

    class ShowIOSRefDocs < URLCommand
      def title;"iOS Reference";end
      def url
        "developer.apple.com/library/ios/navigation/#section=Resource%20Types&topic=Reference"
      end
    end

    class DocsLookupCommand < DocumentCommand

      def self.supported_apps
        ["ClamShell","Dash","Ingredients","Motion RI"]
      end

      def text
        word = doc.selection? ? doc.selected_text : doc.current_word || ""
        case launcher
        when "Ingredients"
          <<-BASH.gsub(/^\s*/, '')
            osascript <<END
              tell application "Ingredients"
                search front window query "#{word}"
                activate
              end tell
            END
          BASH
        when "Dash"
          "open dash://#{word}"
        when "ClamShell"
          x, y = Swt::GraphicsUtils.below_pixel_location_at_offset(doc.edit_view.cursor_offset)
          height = ApplicationSWT.display.primaryMonitor.bounds.height
          width  = ApplicationSWT.display.primaryMonitor.bounds.width
          "open 'clamshell://searchText=#{word}&x=#{x}&y=#{height - y}'"
        when "Motion RI"
          line_offset     = doc.offset_at_line(doc.cursor_line)
          cursor_offset   = doc.cursor_offset
          relative_offset = cursor_offset - line_offset
          next_line = doc.line_at_offset(doc.offset_at_line(doc.cursor_line + 1) + relative_offset)
          if next_line == doc.cursor_line + 1
            line_offset = doc.offset_at_line(next_line)
            cursor_offset = line_offset + relative_offset
            position = [line_offset, cursor_offset - 20].max
          else
            position = :below_cursor
          end
          Application::Dialog.popup_text(word, `motion ri #{word}`, position, [560, 20])
        else
          Redcar::Application::Dialog.message_box(
            "The selected documentation launcher is not supported. Please update Preferences > Cocoa > documentation_launcher. \
            Supported launchers: #{DocsLookupCommand.supported_apps.join(', ')}.",
            "Documentation Reference Failed")
          ""
        end
      end

      def launcher
        @launcher ||= Cocoa.storage['documentation_launcher']
      end

      def execute
        path = "#{launcher.downcase}_path"
        if launcher == "Motion RI" or File.exists?(Cocoa.storage[path])
          if command = text
            Thread.new do
              system("#{command}")
            end
          end
        else
          Redcar::Application::Dialog.message_box(
            "#{launcher} app is not installed or not found at the configured location in Preferences > Cocoa > #{path}. Please install it or update your settings",
            "Documentation Reference Failed")
        end
      end
    end
  end
end