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

    class ShowDocsCommand < URLCommand
      sensitize :edit_tab_focussed
      def word
        @word ||=begin
          win  = Redcar.app.focussed_window
          if win and tab = win.focussed_notebook_tab
            tab.edit_view.document.current_word
          else
            ""
          end
        end
      end

      def title;word;end
      def url
        text = word
        framework = framework_from_class(text)
        if text.empty?
          message("Class name not found under cursor")
          nil
        elsif framework.nil?
          message("Framework not found for class #{text}")
          nil
        else
          base = "developer.apple.com/library/ios/documentation"
          if framework == "Foundation"
            "#{base}/Cocoa/Reference/#{framework}/Classes/#{text}_Class/index.html"
          else
            "#{base}/#{framework}/Reference/#{text}_Class/index.html"
          end
        end
      end

      def framework_from_class text
        case text
        when /^AB/
          "AddressBookUI"
        when /^CA/
          "GraphicsImaging"
        when /^CG/
          "CoreGraphics"
        when /^EK/
          "EventKitUI"
        when /^GK/
          "GameKit"
        when /^MK/
          "MapKit"
        when /^NS/
          "Foundation"
        when /^TW/
          "Twitter"
        when /^UI/
          "UIKit"
        end
      end
    end
  end
end
