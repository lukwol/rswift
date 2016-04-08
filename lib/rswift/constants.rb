require 'xcodeproj'

module RSwift
  module Constants

    CONFIGURATION_PROPERTIES = {
      debug: {
        name: 'Debug'
      }.freeze,
      release: {
        name: 'Release'
      }
    }.freeze

    TEMPLATE_PROPERTIES = {
        ios: {
            target_types: [:application, :unit_test_bundle].freeze,
            sdk: "iOS #{Xcodeproj::XcodebuildHelper.new.last_ios_sdk}"
        }.freeze,
        osx: {
            target_types: [:application, :unit_test_bundle].freeze,
            sdk: "OSX #{Xcodeproj::XcodebuildHelper.new.last_osx_sdk}"
        }.freeze,
        tvos: {
            target_types: [:application, :unit_test_bundle].freeze,
            sdk: "tvOS #{Xcodeproj::XcodebuildHelper.new.last_tvos_sdk}"
        }.freeze,
        watchos: {
            target_types: [:watch2_app, :watch2_extension].freeze,
            sdk: "watchOS #{Xcodeproj::XcodebuildHelper.new.last_watchos_sdk}"
        }.freeze
    }.freeze

    TARGET_PROPERTIES = {
        application: {
            group_name: 'app',
            suffix: '',
            configuration_key: 'app_group'
        }.freeze,
        unit_test_bundle: {
            group_name: 'spec',
            suffix: 'Specs',
            configuration_key: 'spec_group'
        }.freeze,
        watch2_app: {
            group_name: 'wk_app',
            suffix: ' WatchKit App',
            configuration_key: 'wk_app_group'
        }.freeze,
        watch2_extension: {
            group_name: 'wk_ext',
            suffix: ' WatchKit Extension',
            configuration_key: 'wk_ext_group'
        }.freeze
    }.freeze

    COMPILE_SOURCES_EXTENSIONS = %w(
    .s
    .c
    .exp
    .cpp
    .m
    .swift
    .metal
    .xcdatamodeld
    .xcdatamodel
    .xcmappingmodel
    ).freeze

    RESOURCES_EXTENSIONS = %w(
    .xcconfig
    .xcassets
    .plist
    .sh
    .scn
    .scnp
    .sks
    .strings
    .xib
    .storyboard
    .apns
    .bundle
    .aiff
    .midi
    .mp3
    .wav
    .au
    .bmp
    .gif
    .jpg
    .png
    .tiff
    .avi
    .mpeg
    .mov
    .xml
    .html
    .css
    .json
    .md
    .txt
    .rtf
    .pdf
    ).freeze
  end
end
