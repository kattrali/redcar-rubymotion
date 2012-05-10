
module Redcar
  class Cocoa
    class TreeMirror
      include Redcar::Tree::Mirror

      def self.tree_title
        "Resources"
      end

      def initialize(project)
        @project = project
      end

      # the default path for resource file, relative
      # to the current project
      def resource_files_path
         File.join(@project.path,'resources')
      end

      # all files in the resource directory and subdirectories
      def files
        Dir[File.join(resource_files_path,'**/*.*')]
      end

      def title
        TreeMirror.tree_title
      end

      # top-level nodes in the tree
      def top
        load
      end

      # remove a given node from the tree.
      # changes are not reflected until the tree is refreshed
      def remove_node node
        @resources.reject! {|n| n.path == node.path }
        @resources.each do |n|
          n.children.reject! {|n2| n2.path == node.path }
        end
      end

      # Add a file to the tree
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
          organize_tree
        end
      end

      # check for added or removed nodes
      def refresh
        unadded = files.select do |f|
          all_leaves.detect {|n| n.path == f}.nil?
        end
        deleted = all_leaves.select do |node|
          !files.include?(node.path)
        end
        deleted.each {|n| remove_node(n)}
        unadded.each {|f| add_file(f)}
        organize_tree
      end

      # sort tree nodes by name and type (directories first)
      # and remove any empty directories
      def organize_tree
        @resources = @resources.sort_by {|n|
          n.text.downcase
        }.sort_by {|n|
          n.is_a?(DirNode) ? 0 : 1
        }.select {|n|
          n.is_a?(ResourceNode) or n.children.size > 0
        }
      end

      # all directory nodes in the tree
      def dirnodes
        @resources.select {|n| n.is_a? DirNode }
      end

      # all file nodes in the tree
      def all_leaves
        @resources.map do |n|
          if n.is_a? ResourceNode
            [n]
          else
            [n.children]
          end
        end.flatten
      end

      # parse resource paths and generate nodes
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
              organize_tree
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
