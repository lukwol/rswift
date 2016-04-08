module Xcodeproj
  class Project

    def name
      path.dirname.split.last.to_s
    end

    def debug_build_configuration
      build_configuration_name = RSwift::Configuration.new.debug_build_configuration
      build_configuration_name ||= RSwift::Constants::CONFIGURATION_PROPERTIES[:debug][:name]
      build_configurations.find do |build_configuration|
        build_configuration.name.eql? build_configuration_name
      end
    end

    def release_build_configuration
      build_configuration_name = RSwift::Configuration.new.release_build_configuration
      build_configuration_name ||= RSwift::Constants::CONFIGURATION_PROPERTIES[:release][:name]
      build_configurations.find do |build_configuration|
        build_configuration.name.eql? build_configuration_name
      end
    end

    def app_target
      targets.find { |target| target.product_type.eql? Xcodeproj::Constants::PRODUCT_TYPE_UTI[:application] }
    end

    def spec_target
      targets.find { |target| target.product_type.eql? Xcodeproj::Constants::PRODUCT_TYPE_UTI[:unit_test_bundle] }
    end

    def wk_app_target
      targets.find { |target| target.product_type.eql? Xcodeproj::Constants::PRODUCT_TYPE_UTI[:watch2_app] }
    end

    def wk_ext_target
      targets.find { |target| target.product_type.eql? Xcodeproj::Constants::PRODUCT_TYPE_UTI[:watch2_extension] }
    end

    def app_scheme_name
      scheme_name = RSwift::Configuration.new.app_scheme_name
      schemes_names = Xcodeproj::Project.schemes(path)
      scheme_name ||= schemes_names.find do |scheme_name|
        is_app_scheme(scheme_for_scheme_name(scheme_name))
      end
      scheme_name
    end

    def app_scheme
      scheme_for_scheme_name(app_scheme_name)
    end

    private

    def scheme_for_scheme_name(scheme_name)
      shared_data_dir = Xcodeproj::XCScheme.shared_data_dir path
      scheme_file_path = "#{shared_data_dir}/#{scheme_name}.xcscheme"
      scheme = Xcodeproj::XCScheme.new(scheme_file_path) if File.exist?(scheme_file_path)
      scheme
    end

    def is_app_scheme(scheme)
      has_proper_launch_action = scheme.launch_action.buildable_product_runnable.buildable_reference.target_uuid.eql?(app_target.uuid)
      has_proper_buildable_action = scheme.profile_action.buildable_product_runnable.buildable_reference.target_uuid.eql?(app_target.uuid)
      has_proper_launch_action && has_proper_buildable_action
    end
  end
end
