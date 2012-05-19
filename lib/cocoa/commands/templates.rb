
module Redcar
  class Cocoa

    # Generator Class for creating a new file from a template
    # path
    class CreateFromTemplateCommand < Redcar::ProjectCommand
      def initialize path
        @path = path
      end

      def template
        File.basename(@path).sub(".snippet","")
      end

      def execute
        if File.exists? @path
          result = Redcar::Application::Dialog.input("File Generator","#{template} Name:")
          if result[:button] == :ok and classname = result[:value].strip
            text = replace_symbols(IO.read(@path), {:name => classname})
            filename  = to_snake_case(classname) + ".rb"
            if directory = Redcar::Application::Dialog.open_directory(project.path)
              file = File.join(directory,filename)
              FileUtils.touch(file)
              snippet = Redcar::Snippets::Snippet.new(nil, text, {})
              if tab = Project::Manager.open_file(file)
                document   = tab.edit_view.document
                controller = document.controllers(Redcar::Snippets::DocumentController).first
                controller.start_snippet!(snippet)
              end
            end
          end
        end
      end

      def replace_symbols text, options
        text.gsub("__NAME__", options[:name])
      end

      private

      def to_snake_case word
        Redcar::EditView::CamelSnakePascalRotateTextCommand.new.pascalcase_to_snakecase(word)
      end
    end
  end
end