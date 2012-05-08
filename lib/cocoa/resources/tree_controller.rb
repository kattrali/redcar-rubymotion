
module Redcar
  class Cocoa
    class TreeController
      include Redcar::Tree::Controller
      include Redcar::Project::LocalFilesystem

      def activated(tree, node)
        Redcar::OpenDefaultApp::OpenDefaultAppCommand.new(node.path).run if node
      end

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