
module Redcar
  class Cocoa

    # Saves the current document as a new template
    class SaveFileAsTemplateCommand < Redcar::DocumentCommand
      def execute
        build_template
      end

      def build_template
        result = Redcar::Application::Dialog.input("File Generator", "New Template Name")
        if result[:button] == :ok and name = result[:value]
          text = doc.get_all_text
          name.sub!(/\.snippet$/,"")
          path = File.join(Cocoa.user_template_path,"#{name}.snippet")
          if File.exists? path
            Redcar::Application::Dialog.message_box("A template named #{name} already exists", "File Generator")
            build_template
          else
            FileUtils.makedirs(Cocoa.user_template_path) unless File.exists?(Cocoa.user_template_path)
            file = File.open(path, 'w') {|f| f.puts text}
            Redcar::Application::Dialog.message_box(
              "Template saved. It should now appear in the template menu.", "File Generator")
          end
        end
      end
    end

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