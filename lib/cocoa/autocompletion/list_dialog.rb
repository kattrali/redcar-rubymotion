module Redcar
  class AutoCompleter
    class ListDialog

      def convert_to_snippet(method)
        method.sub(/^(\w+):(.*)/,"\\1(${1;param},\\2)").gsub(":").each_with_index{|match,i|
          ":${#{i+2};param},"
        }.sub(",)",")").gsub(";",":")
      end

      def self.grammars
        ['RubyMotion','RSpec','MacBacon','MacRuby']
      end

      def convert? text
        ListDialog.grammars.include?(@doc.edit_view.grammar) && text =~ /^(\w+:)+$/
      end

      def selected(index)
        if text = select(index)
          offset = @doc.cursor_offset - @prefix.length
          if convert? text
            @doc.replace(offset, @prefix.length, "")
            text = convert_to_snippet(text)
            snippet = Redcar::Snippets::Snippet.new(nil, text)
            controller = @doc.controllers(Redcar::Snippets::DocumentController).first
            controller.start_snippet!(snippet)
          else
            @doc.replace(offset, @prefix.length, text)
          end
          close
        end
      end
    end
  end
end
