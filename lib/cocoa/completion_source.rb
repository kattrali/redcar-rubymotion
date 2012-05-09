module Redcar
  class Cocoa
    class CompletionSource
      def initialize(_, project)
        @project = project
      end

      def alternatives(prefix)
        if @project
          word_list = Redcar::AutoCompleter::WordList.new
          tags = CompletionSource.project_tags(@project)
          tags.keys.each do |tag|
            if tag[0..(prefix.length-1)] == prefix
              tag = CompletionSource.convert_objc(tag) if tag.include?(":") && tag =~ /^(\w+:)+$/
              word_list.add_word(tag, 10001)
            end
          end
          word_list
        end
      end

      def self.tags_file(project)
        File.join(project.path,'tags')
      end

      def self.convert_objc(method)
        method.sub(/^(\w+):(.*)/,"\\1(param,\\2)").gsub(":",":param,").sub(",)",")")
      end

      def self.project_tags(project)
        path = tags_file(project)
        Cocoa::GenerateTagsCommand.new.run unless File.exists?(path)
        if File.exists? path
          @tags_for_path ||= {}
          @tags_for_path[path] ||= begin
            tags = {}
            ::File.read(path).each_line do |line|
              key, file, *match = line.split("\t")
              if [key, file, match].all? { |el| !el.nil? && !el.empty? }
                tags[key] ||= []
                tags[key] << { :file => file, :match => match.join("\t").chomp }
              end
            end
            tags
          rescue Errno::ENOENT
            {}
          end
        else
          # Redcar::Application::Dialog.message_box(
          # "No 'tags' file found for project. Generate a tags file by running 'rake ctags' in the root of the project",
          # "Uh oh")
          {}
        end
      end
    end
  end
end