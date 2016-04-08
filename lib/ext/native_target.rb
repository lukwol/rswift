module Xcodeproj
  class Project
    module Object
      class PBXNativeTarget

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

        def product_name
          product_name = RSwift::Configuration.new.product_name
          product_name ||= super
          product_name
        end

        def product_type_uti
          Xcodeproj::Constants::PRODUCT_TYPE_UTI.key(product_type)
        end

        def suffix
          RSwift::Constants::TARGET_PROPERTIES[product_type_uti][:suffix]
        end

        def group_name
          RSwift::Constants::TARGET_PROPERTIES[product_type_uti][:group_name]
        end

        def debug_product_bundle_identifier
          product_bundle_identifier = RSwift::Configuration.new.debug_product_bundle_identifier
          product_bundle_identifier ||= debug_build_configuration.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
          product_bundle_identifier
        end

        def release_product_bundle_identifier
          product_bundle_identifier = RSwift::Configuration.new.release_product_bundle_identifier
          product_bundle_identifier ||= release_build_configuration.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
          product_bundle_identifier
        end
      end
    end
  end
end
