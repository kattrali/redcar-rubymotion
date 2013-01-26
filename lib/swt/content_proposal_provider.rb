
module Redcar
  class Cocoa
    # org.eclipse.jface.fieldassist
    # Interface IContentProposalProvider
    class ContentProposalProvider
      class Proposal
        def initialize(content)
          @content = content
        end

        def getContent
          @content
        end

        def getCursorPosition
          @content.length
        end

        def getDescription
          nil
        end

        def getLabel
          @content
        end
      end

      def initialize document, project
        @doc, @project = document, project
      end

      # Return an array of content proposals representing the valid proposals for a field.
      # Parameters:
      #   contents - the current contents of the text field
      #   position - the current position of the cursor in the contents
      # Returns:
      #   the array of IContentProposal that represent valid proposals for the field.
      def getProposals contents, position
        prefix  = @doc.current_word
        tags    = Cocoa::CompletionSource.project_tags(@project)
        results = tags.select do |tag|
          tag[0..(prefix.length-1)].casecmp(prefix) == 0 && tag.length > prefix.length
        end.map {|tag| Proposal.new(tag)}
        results[0..20]
      end
    end
  end
end