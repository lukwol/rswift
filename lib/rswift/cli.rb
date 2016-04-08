require 'thor'

module RSwift
  class CLI < Thor
    attr_accessor :template_manager
    attr_accessor :project_configurator

    def initialize(args = [], local_options = {}, config = {})
      super
      @template_manager = RSwift::TemplateManager.new
      @project_configurator = RSwift::ProjectConfigurator.new
    end

    desc 'app NAME', 'create new empty application project'
    option :template

    def app(name)
      template = options[:template]
      template ||= 'ios'
      template = template.to_sym
      abort 'Available templates: ios (default), osx, tvos, watchos' unless RSwift::Constants::TEMPLATE_PROPERTIES.keys.include? template
      abort 'Not implemented yet' if template == :watchos

      @template_manager.create_files_for_template(name, template)

      project_path = "#{name}/#{name}.xcodeproj"
      project = Xcodeproj::Project.new project_path
      @project_configurator.configure_project(project, template)
      project.save
      say_status :generate, project_path
    end
  end
end
