
module GDI::Debugger::Files
  class RubyMotionLinker < DefaultLinker

    def find_links(text)
      links = []
      while (match_begin = text =~ /(#{file_pattern})/)
        match_text = $1
        line = $3.to_i + 1

        if path = parse_path($2)
          link = add_file_link(match_text, path, line)
          links << link
          text = text[match_begin + link[:match].length..-1]
        end
      end
      links
    end

    def file_pattern
      /((?:[A-Za-z_\.0-9\/\s])+\.rb):([1-9][0-9]*)/
    end

    def parse_path path
      unless File.exists?(path)
        if project = Redcar::Project::Manager.focussed_project
          if File.exist?(File.join(project.path,path))
            path = File.join(project.path,path)
          elsif possible = Dir.glob(File.join(project.path,'**',path))
            path = possible.first if possible.any?
          else
            puts "no path found: #{path}"
          end
        end
      end
      path if File.exists?(path)
    end
  end
end