module Redcar
  class Cocoa
    class OpenResourcesTree < Redcar::ProjectCommand
      def execute
        if tree = win.treebook.trees.detect {|tree| tree.tree_mirror.title == "Resources" }
          tree.refresh
          win.treebook.focus_tree(tree)
        else
          tree = Tree.new(
            Redcar::Cocoa::TreeMirror.new(project),
            Redcar::Cocoa::TreeController.new
          )
          win.treebook.add_tree(tree)
        end
      end
    end
  end
end