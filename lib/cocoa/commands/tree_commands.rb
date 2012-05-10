module Redcar
  class Cocoa
    class OpenResourcesTree < Redcar::ProjectCommand
      def execute
        if tree = win.treebook.trees.detect {|tree| tree.tree_mirror.title == TreeMirror.tree_title }
          tree.refresh
          win.treebook.focus_tree(tree)
        else
          mirror = Redcar::Cocoa::TreeMirror.new(project)
          tree = Tree.new(
            mirror,
            Redcar::Cocoa::TreeController.new(mirror)
          )
          win.treebook.add_tree(tree)
        end
      end
    end
  end
end