
module Redcar
  class Cocoa
    class TreeMirror
      include Redcar::Tree::Mirror

      def initialize(project)
        @project = project
      end

      def resource_files_path
         File.join(@project.path,'resources')
      end

      def files
        Dir[File.join(resource_files_path,'**/*.*')]
      end

      def title
        "Resources"
      end

      def top
        load
      end

      def remove_node node
        @resources.reject! {|n| n.path == node.path }
        @resources.each do |n|
          n.children.reject! {|n2| n2.path == node.path }
        end
      end

      def add_file path
        unless all_leaves.map {|n|n.path}.include? path
          node = ResourceNode.new(path)
          if parent = Cocoa::DirNode.directories.detect {|dir| dir.extensions.include?(node.extension)}
            if parent_node = @resources.detect {|n| n.is_a?(parent)}
              parent_node.children << node
              parent_node.children = parent_node.children.sort_by {|n| n.text.downcase }
            else
              parent_node = parent.new([node])
            end
          else
            @resources << node
          end
          sort
        end
      end

      def refresh
        unless files == all_leaves.map {|n|n.path}
          @resources = nil
          load
        end
      end

      def sort
        @resources = @resources.sort_by {|n| n.text.downcase }.sort_by {|n| n.is_a?(DirNode) ? 0 : 1 }
      end

      def all_leaves
        @resources.map do |n|
          if n.is_a? ResourceNode
            [n]
          else
            [n.children]
          end
        end.flatten
      end
      def load
        unless @resources
          @resources = []
          if File.exists?(resource_files_path)
            begin
              child_nodes = files.map {|f| ResourceNode.new(f) }
              Cocoa::DirNode.directories.each do |dir|
                if children = child_nodes.select {|n| dir.extensions.include?(n.extension)}
                  @resources << dir.new(children)
                  child_nodes.reject! {|n| children.include?(n)}
                end
              end
              @resources += child_nodes
              @resources.reject! {|n| n.is_a?(Cocoa::DirNode) and n.children.size == 0}
              sort
            rescue Object => e
              Redcar::Application::Dialog.message_box(
                "There was an error parsing the resources file list: #{e.message}")
              []
            end
          end
        end
        @resources
      end
    end
  end
end