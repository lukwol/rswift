module RSwift
  class SchemeConfigurator
    def configure_app_scheme(project, scheme)
      scheme.add_build_target(project.app_target)
      scheme.set_launch_target(project.app_target)
      scheme.add_test_target(project.spec_target)
      scheme.save_as(project.path, project.name)
    end
  end
end
