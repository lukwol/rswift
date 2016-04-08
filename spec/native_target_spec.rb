require 'rspec'
require 'rswift'

describe Xcodeproj::Project::Object::PBXNativeTarget do

  before do
    @project = Xcodeproj::Project.new('FixtureProject/FixtureProject.xcodeproj')
    @sut = @project.new_target(:application, 'FixtureProject', :ios)
    @sut.debug_build_configuration.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'fixtureDebugBundleIdentifier'
    @sut.release_build_configuration.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'fixtureReleaseBundleIdentifier'
    allow_any_instance_of(Xcodeproj::Project::Object::XCBuildConfiguration).to receive(:pretty_print)
    stub_const("Xcodeproj::Constants::PRODUCT_TYPE_UTI", {fixture_product_type_uti: 'com.apple.product-type.application'})
    stub_const("RSwift::Constants::TARGET_PROPERTIES", {fixture_product_type_uti: {suffix: 'fixture suffix', group_name: 'fixture group name'}})
  end

  it 'should have proper debug build configuration' do
    expected_debug_configuration = @sut.build_configurations.find do |build_configuration|
      build_configuration.name.eql?('Debug')
    end
    expect(@sut.debug_build_configuration).to eq(expected_debug_configuration)
  end

  it 'should have proper release build configuration' do
    expected_release_configuration = @sut.build_configurations.find do |build_configuration|
      build_configuration.name.eql? 'Release'
    end
    expect(@sut.release_build_configuration).to eq(expected_release_configuration)
  end

  it 'should have proper product type uti' do
    expect(@sut.product_type_uti).to eq(:fixture_product_type_uti)
  end

  it 'should have proper suffix' do
    expect(@sut.suffix).to eq('fixture suffix')
  end

  it 'should have proper group name' do
    expect(@sut.group_name).to eq('fixture group name')
  end

  it 'should have proper debug product bundle identifier' do
    expect(@sut.debug_product_bundle_identifier).to eq('fixtureDebugBundleIdentifier')
  end

  it 'should have proper release product bundle identifier' do
    expect(@sut.release_product_bundle_identifier).to eq('fixtureReleaseBundleIdentifier')
  end
end
