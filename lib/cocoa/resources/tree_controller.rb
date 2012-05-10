
module Redcar
  class Cocoa
    class TreeController
      include Redcar::Tree::Controller
      include Redcar::Project::LocalFilesystem

      def initialize(tree_mirror)
        @mirror = tree_mirror
        attach_listeners
      end

      # Open selected node path in default application
      # on double-click
      def activated(tree, node)
        Redcar::OpenDefaultApp::OpenDefaultAppCommand.new(node.path).run if node
      end

      # Attach change listeners to determine whether resource
      # files have been added or deleted. Checks are performed
      # when window or tree gains focus
      def attach_listeners
        Redcar.app.add_listener(:window_focussed) do |win|
          if tree = win.treebook.trees.detect {|t| t.tree_mirror == @mirror }
            @mirror.refresh
            tree.refresh
          end
        end
        win = Redcar.app.focussed_window
        win.treebook.add_listener(:tree_focussed) do |tree|
          if tree.tree_mirror == @mirror
            @mirror.refresh
            tree.refresh
          end
        end
      end

      # Show a context menu on click
      def right_click(tree, node)
        controller = self
        menu = Menu::Builder.build do
          if node and node.leaf?
            item("Open in Default App") {
              Redcar::OpenDefaultApp::OpenDefaultAppCommand.new(node.path).run
            }
            item("Move to Trash") {
              nodes = tree.selection.select {|n| n.path }
              basenames = nodes.map {|n| File.basename(n.path) }
              msg = "Really delete #{basenames.join(", ")}?"
              result = Application::Dialog.message_box(msg, :type => :question, :buttons => :yes_no)
              if result == :yes
                nodes.each do |n|
                  controller.fs.delete(n.path)
                  tree.tree_mirror.remove_node(n)
                end
                tree.refresh
              end
            }
            separator
          end
          item("Add Resource...") {
            win = Redcar.app.focussed_window
            if path = Redcar::Application::Dialog.open_file({}) and File.dirname(path) != tree.tree_mirror.resource_files_path
              begin
                FileUtils.cp(path, tree.tree_mirror.resource_files_path)
                tree.tree_mirror.add_file(path)
                tree.refresh
              rescue Exception => e
                p e.message
                p e.backtrace
                Redcar::Application::Dialog.message_box("The selected file could not be copied", "uh oh")
              end
            end
          }
        end
        Application::Dialog.popup_menu(menu, :pointer)
      end
    end
  end
end
