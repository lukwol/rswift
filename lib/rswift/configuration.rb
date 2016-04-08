require 'yaml'

module RSwift
  class Configuration

    def initialize
      yaml_file = '.rswift.yml'
      @config = YAML.load_file(yaml_file) if File.exist?(yaml_file)
    end

    def app_scheme_name
      @config['app_scheme_name'] if @config
    end

    def product_name
      @config['product_name'] if @config
    end

    def debug_build_configuration
      @config['debug_build_configuration'] if @config
    end

    def release_build_configuration
      @config['release_build_configuration'] if @config
    end

    def debug_product_bundle_identifier
      @config['debug_product_bundle_identifier'] if @config
    end

    def release_product_bundle_identifier
      @config['release_product_bundle_identifier'] if @config
    end

    def group_name(target)
      group_name = @config[RSwift::Constants::TARGET_PROPERTIES[target.product_type_uti][:configuration_key]] if @config
      group_name ||= RSwift::Constants::TARGET_PROPERTIES[target.product_type_uti][:group_name]
      group_name
    end
  end
end
