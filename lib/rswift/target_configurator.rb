module RSwift
  class TargetConfigurator

    attr_accessor :build_settings_configurator
    attr_accessor :files_references_manager

    def initialize
      @build_settings_configurator = RSwift::BuildSettingsConfigurator.new
      @files_references_manager = RSwift::FilesReferencesManager.new
    end

    def configure_target(project, target, template)
      @build_settings_configurator.configure_target_settings(project, target, template)
      group = project.new_group(target.group_name, target.group_name)
      @files_references_manager.update_target_references(group, target)
    end

    def configure_targets_dependencies(project)
      project.spec_target.add_dependency(project.app_target)
    end
  end
end
