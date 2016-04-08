module RSwift
  class BuildSettingsProvider

    def project_debug_settings(template)
      options = [template, :debug]
      project_build_settings(options)
    end

    def project_release_settings(template)
      options = [template, :release]
      project_build_settings(options)
    end

    def target_debug_settings(project, target, template)
      options = [template, target.product_type_uti, :debug]
      target_build_settings(project, target, options)
    end

    def target_release_settings(project, target, template)
      options = [template, target.product_type_uti, :release]
      target_build_settings(project, target, options)
    end

    private

    def settings(constants, options)
      all_constant_settings = {}
      settings_combinations = options.all_combinations
      settings_combinations.each do |combination|
        constant_settings = constants[combination]
        all_constant_settings.merge! constant_settings if constant_settings
      end
      all_constant_settings
    end

    def project_build_settings(options)
      project_settings = {
          [:debug] => {
              'ENABLE_TESTABILITY' => 'YES'
          }.freeze
      }.freeze
      settings(project_settings, options)
    end

    def target_build_settings(project, target, options)
      target_settings = {
          [] => {
              'INFOPLIST_FILE' => "#{target.group_name}/Info.plist"
          }.freeze,
          [:ios] => {
              'TARGETED_DEVICE_FAMILY' => '1,2'
          }.freeze,
          [:application] => {
              'PRODUCT_BUNDLE_IDENTIFIER' => "com.rswift.#{target.name}"
          }.freeze,
          [:unit_test_bundle] => {
              'PRODUCT_BUNDLE_IDENTIFIER' => "com.rswift.#{target.name}",
              'BUNDLE_LOADER' => '$(TEST_HOST)',
          }.freeze,
          [:watch2_app] => {
              'PRODUCT_BUNDLE_IDENTIFIER' => "com.rswift.#{project.app_target}.watchkitapp"
          }.freeze,
          [:watch2_extension] => {
              'PRODUCT_BUNDLE_IDENTIFIER' => "com.rswift.#{project.app_target}.watchkitapp.watchkitextension"
          }.freeze,
          [:ios, :unit_test_bundle] => {
              'TEST_HOST' => "$(BUILT_PRODUCTS_DIR)/#{project.app_target.name}.app/#{project.app_target.name}"
          }.freeze,
          [:osx, :unit_test_bundle] => {
              'TEST_HOST' => "$(BUILT_PRODUCTS_DIR)/#{project.app_target.name}.app/Contents/MacOS/#{project.app_target.name}",
              'LD_RUNPATH_SEARCH_PATHS' => %w($(inherited) @loader_path/../Frameworks @executable_path/../Frameworks),
              'COMBINE_HIDPI_IMAGES' => 'YES'
          }.freeze,
          [:tvos, :application] => {
              'LD_RUNPATH_SEARCH_PATHS' => %w($(inherited) @executable_path/Frameworks)
          }.freeze,
          [:tvos, :unit_test_bundle] => {
              'TEST_HOST' => "$(BUILT_PRODUCTS_DIR)/#{project.app_target.name}.app/#{project.app_target.name}"
          }.freeze
      }.freeze
      settings(target_settings, options)
    end
  end
end
