module Redcar
  class Cocoa
    class CompletionSource
      def initialize(_, project)
        @project = project
      end

      # a Redcar::AutoCompleter::WordList of autocompletions
      # based on a given prefix
      def alternatives(prefix)
        if @project
          word_list = Redcar::AutoCompleter::WordList.new
          tags = CompletionSource.project_tags(@project)
          tags.keys.sort_by{|tag| tag.downcase}.each do |tag|
            if tag[0..(prefix.length-1)] == prefix
              word_list.add_word(tag, 10001)
            end
          end
          word_list
        end
      end

      # the default location of a tags file within a project
      def self.tags_file(project)
        File.join(project.path,'tags')
      end

      # clear cached version of a project's tags
      def self.clear_cache(project)
        @tags_for_path[tags_file(project)] = nil if @tags_for_path
      end

      # A hash of a project's ctags, divided by token
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
          {}
        end
      end
    end
  end
end