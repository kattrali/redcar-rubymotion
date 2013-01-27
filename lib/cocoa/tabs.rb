
module Redcar
  class Cocoa
    class ReferenceTab < HtmlTab
      def icon
        :"ui-check-boxes-series"
      end
    end
  end

  class EditTab
    attr_accessor :proposal_adapter
  end
end