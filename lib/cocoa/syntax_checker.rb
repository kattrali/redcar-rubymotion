
module Redcar
  class Cocoa
    class SyntaxChecker < Redcar::SyntaxCheck::Checker
      supported_grammars "Ruby","MacRuby"

      def check(*args)
        path = manifest_path(doc)
        file = File.basename(path)
        begin
          macruby = Cocoa.storage['macruby_path']
          encoding = Cocoa.storage['encoding']
          command = "#{macruby} -E #{encoding} -c \"#{path}\""
          pid, input, output, error = IO.popen4(command)
          error.each do |line|
            if error = create_syntax_error(doc, line, file)
              error.annotate
            end
          end
        rescue SyntaxError => e
          if error = create_syntax_error(doc, e.exception.message, file)
            error.annotate
          end
        end
      end

      def create_syntax_error(doc, message, file)
        if message  =~ /#{Regexp.escape(file)}:(\d+):(.*)/
          line     = $1.to_i - 1
          message  = $2
          Redcar::SyntaxCheck::Error.new(doc, line, message)
        end
      end
    end
  end
end