module RSwift
  class FilesReferencesManager

    attr_accessor :group_references_manager

    def initialize
      @group_references_manager = RSwift::GroupReferencesManager.new(self)
    end

    def update_target_references(group, target)
      @group_references_manager.update_files_references(group, target)
      @group_references_manager.update_directory_references(group, target)
      @group_references_manager.cleanup_invalid_references(group)
      @group_references_manager.cleanup_build_files(target)
    end
  end
end
