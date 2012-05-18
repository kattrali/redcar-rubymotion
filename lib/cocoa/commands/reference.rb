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
        ["Dash","Ingredients"]
      end

      def text
        word = doc.current_word
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
        if File.exists?(Cocoa.storage[path])
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