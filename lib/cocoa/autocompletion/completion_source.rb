module Redcar
  class Cocoa
    class CompletionSource

      # the default location of a tags file within a project
      def self.tags_file(project)
        File.join(project.path,'tags')
      end

      # clear cached version of a project's tags
      def self.clear_cache(project)
        @tags = nil
      end

      # A hash of a project's ctags, divided by token
      def self.project_tags(project)
        path = tags_file(project)
        Cocoa::GenerateTagsCommand.new.run unless File.exists?(path)
        @tags ||= begin
          decl_tags_path = Declarations.file_path(project)
          tags_in_file(path).concat(tags_in_file(decl_tags_path)).uniq.sort
        end
      end

      def self.tags_in_file path
        tags = []
        if File.exists? path
          begin
            ::File.read(path).each_line do |line|
              key, file, *match = line.split("\t")
              if [key, file, match].all? { |el| !el.nil? && !el.empty? }
                tags << key
              end
            end
          rescue Errno::ENOENT
          end
        end
        tags
      end
    end
  end
end