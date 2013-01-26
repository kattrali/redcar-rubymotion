
module Redcar
  class Cocoa
    class DirNode
      include Redcar::Tree::Mirror::NodeMirror
      attr_accessor :children

      def path
        nil
      end

      def self.directories
        [
          StringsDirNode,
          FontDirNode,
          ImagesDirNode,
          DatabaseDirNode,
          SoundDirNode,
          InterfaceDirNode
        ]
      end

      def initialize(children)
        @children = children
      end

      def children
        @children ||= []
      end

      def text
        "Directory"
      end

      def leaf?
        false
      end

      def icon
        :"blue-folder-open"
      end
    end

    class VideoDirNode < DirNode
      include Redcar::Tree::Mirror::NodeMirror

      def self.extensions
        ['mov','avi','mp4','m4v']
      end

      def text
        "Video"
      end

      def icon
        :"blue-folder-open-film"
      end
    end

    class StringsDirNode < DirNode
      include Redcar::Tree::Mirror::NodeMirror

      def self.extensions
        ['strings','plist']
      end

      def text
        "Properties"
      end

      def icon
        :"blue-folder-open-document-text"
      end
    end

    class FontDirNode < DirNode
      include Redcar::Tree::Mirror::NodeMirror
      def self.extensions
        ['ttf','otf']
      end

      def text
        "Fonts"
      end

      def icon
        :"blue-folder-open"
      end
    end

    class SoundDirNode < DirNode
      include Redcar::Tree::Mirror::NodeMirror
      def self.extensions
        ['mp3','aac']
      end

      def text
        "Sounds"
      end

      def icon
        :"blue-folder-open-document-music"
      end
    end

    class ImagesDirNode < DirNode
      include Redcar::Tree::Mirror::NodeMirror
      def self.extensions
        ['gif','png','jpg','jpeg','psd','ai']
      end

      def text
        "Images"
      end

      def icon
        :"blue-folder-open-image"
      end
    end

    class InterfaceDirNode < DirNode
      include Redcar::Tree::Mirror::NodeMirror
      def self.extensions
        ['xib','storyboard']
      end

      def text
        "Interfaces"
      end

      def icon
        :"blueprints"
      end
    end

    class DatabaseDirNode < DirNode
      include Redcar::Tree::Mirror::NodeMirror
      def self.extensions
        ['db','sqlite','xcdatamodeld','xcdatamodel']
      end

      def text
        "Databases"
      end

      def icon
        :"databases"
      end
    end

    class ResourceNode
      include Redcar::Tree::Mirror::NodeMirror
      attr_reader :path

      def initialize(path)
        @path = path
      end

      def icon
        case extension
        when *ImagesDirNode.extensions
          extension == 'psd' ? :"document-photoshop-image" : :"document-image"
        when *DatabaseDirNode.extensions
          :database
        when *StringsDirNode.extensions
          :"document-text"
        when *InterfaceDirNode.extensions
          :blueprint
        when *SoundDirNode.extensions
          :"document-music"
        when *FontDirNode.extensions
          :"layer-shape-text"
        else
          :document
        end
      end

      def text
        File.basename(path)
      end

      def leaf?
        File.file?(path)
      end

      def extension
        File.basename(path).split('.').last.downcase
      end

      def children
        []
      end
    end
  end
end
