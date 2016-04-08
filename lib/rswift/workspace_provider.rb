require 'colorize'

module RSwift
  class WorkspaceProvider
    def self.workspace
      workspace = Dir.glob(['*.xcworkspace']).first
      raise 'xcworkspace not found, did you install pods?'.red unless workspace
      workspace
    end
  end
end
