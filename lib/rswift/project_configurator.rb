require 'xcodeproj'

module RSwift
  class ProjectConfigurator
    attr_accessor :build_settings_configurator
    attr_accessor :target_configurator
    attr_accessor :attributes_configurator
    attr_accessor :scheme_configurator

    def initialize
      @build_settings_configurator = RSwift::BuildSettingsConfigurator.new
      @target_configurator = RSwift::TargetConfigurator.new
      @attributes_configurator = RSwift::AttributesConfigurator.new
      @scheme_configurator = RSwift::SchemeConfigurator.new
    end

    def configure_project(project, template)
      setup_targets(project, template)
      setup_schemes project
      @build_settings_configurator.configure_project_settings(project, template)
      @attributes_configurator.configure_project_attributes project
    end

    private

    def setup_targets(project, template)
      target_types = RSwift::Constants::TEMPLATE_PROPERTIES[template][:target_types]
      target_types.each do |target_type|
        target_properties = RSwift::Constants::TARGET_PROPERTIES[target_type]
        target = project.new_target(target_type, "#{project.name}#{target_properties[:suffix]}", template)
        @target_configurator.configure_target(project, target, template)
      end
      @target_configurator.configure_targets_dependencies project
    end

    def setup_schemes(project)
      scheme = Xcodeproj::XCScheme.new
      @scheme_configurator.configure_app_scheme(project, scheme)
    end
  end
end
