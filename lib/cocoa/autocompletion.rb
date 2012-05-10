module Redcar
  class Cocoa
    class Autocompletion

      # Are Cocoa-type completions valid in a given
      # document?
      def self.supported? document
        supported_grammars.include? doc.edit_view.grammar
      end

      # Are there any Objective-C methods detected in
      # a given chunk of text?
      def self.is_objc? blob, find_in_line=false
        !!parse_objc(blob, find_in_line)
      end

      # Grammars supported by Cocoa plugin autocompletions
      def self.supported_grammars
        ['RubyMotion','RSpec','MacRuby','Ruby']
      end

      # Regular expression for matching Objective-C methods
      def self.objc_matcher find_in_line=false
        find_in_line ? /#{matcher}/ : /^#{matcher}$/
      end

      # Parse a given chunk of text and find the first
      # occurrence of an Objectve-C method. `find_in_line`
      # determines whether to consider partial matches
      def self.parse_objc text, find_in_line=false
        matcher = '((\w+:)+)'
        regex = objc_matcher(find_in_line)
        if match = regex.match(text)
          {
            'method' => match.captures.first,
            'bounds' => match.offset(0)
          }
        end
      end

      # Convert an Objective-C method tag into a snippet
      def self.method_to_snippet method
        args = method.split(':')
        text = args.each_with_index.map do |arg,i|
          "#{a}:${#{i+1}:param}"
        end.join(", ").sub(/:(.*)/,"(\\1)")
        Redcar::Snippets::Snippet.new(nil, text)
      end
    end
  end
end