module RSwift
  class AttributesConfigurator
    
    def configure_project_attributes(project)
      project.root_object.attributes.merge! target_attributes(project)
    end

    private

    def target_attributes(project)
      {
        'TargetAttributes' => {
          project.spec_target.uuid => {
            'TestTargetID' => project.app_target.uuid
          }.freeze
        }.freeze
      }.freeze
    end
  end
end
