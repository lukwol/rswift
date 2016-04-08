module RSwift
  class BuildSettingsConfigurator

    attr_accessor :build_settings_provider

    def initialize
      @build_settings_provider = RSwift::BuildSettingsProvider.new
    end

    def configure_project_settings(project, template)
      project_debug_settings = @build_settings_provider.project_debug_settings(template)
      project.debug_build_configuration.build_settings.merge! project_debug_settings

      project_release_settings = @build_settings_provider.project_release_settings(template)
      project.release_build_configuration.build_settings.merge! project_release_settings
    end

    def configure_target_settings(project, target, template)
      target_debug_settings = @build_settings_provider.target_debug_settings(project, target, template)
      target.debug_build_configuration.build_settings.merge! target_debug_settings

      target_release_settings = @build_settings_provider.target_release_settings(project, target, template)
      target.release_build_configuration.build_settings.merge! target_release_settings
    end
  end
end
