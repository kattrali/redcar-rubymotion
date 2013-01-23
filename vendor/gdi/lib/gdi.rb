$:.unshift(File.dirname(__FILE__))

require 'patches/try'
require 'gdi/actions'
require 'gdi/tab'
require 'gdi/process_controller'

class GDI
  def self.debuggers
    @debuggers ||= []
  end
end

require 'gdi/debugger'

