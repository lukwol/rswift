require 'rspec'
require 'rswift'

describe Xcodeproj::Project do

  before do
    @sut = Xcodeproj::Project.new('FixtureProject/FixtureProject.xcodeproj')
    @app_target = @sut.new_target(:application, 'FixtureProject', :ios)
    @spec_target = @sut.new_target(:unit_test_bundle, 'FixtureProjectSpecs', :ios)

    allow(Xcodeproj::Project).to receive(:schemes).and_return(['fixtureScheme'])
    spy_configuration = spy(app_scheme_name: nil, debug_build_configuration: nil, release_build_configuration: nil)
    allow(RSwift::Configuration).to receive(:new).and_return(spy_configuration)
    allow(File).to receive(:exist?).with("#{@sut.path}/xcshareddata/xcschemes/fixtureScheme.xcscheme").and_return(true)
    launch_action = spy(buildable_product_runnable: Xcodeproj::XCScheme::BuildableProductRunnable.new(@app_target, 0))
    profile_action = spy(buildable_product_runnable: Xcodeproj::XCScheme::BuildableProductRunnable.new(@app_target))
    @spy_scheme = spy(launch_action: launch_action, profile_action: profile_action)
    allow(Xcodeproj::XCScheme).to receive(:new).and_return(@spy_scheme)
  end

  it 'should have proper name' do
    expect(@sut.name).to eq('FixtureProject')
  end

  it 'should have proper debug build configuration' do
    expected_debug_configuration = @sut.build_configurations.find do |build_configuration|
      build_configuration.name.eql? 'Debug'
    end
    expect(@sut.debug_build_configuration).to eq(expected_debug_configuration)
  end

  it 'should have proper release build configuration' do
    expected_release_configuration = @sut.build_configurations.find do |build_configuration|
      build_configuration.name.eql? 'Release'
    end
    expect(@sut.release_build_configuration).to eq(expected_release_configuration)
  end

  it 'should have proper app target' do
    expect(@sut.app_target).to eq(@app_target)
  end

  it 'should have proper spec target' do
    expect(@sut.spec_target).to eq(@spec_target)
  end

  it 'should have proper wk app target' do
    expect(@sut.wk_app_target).to eq(@wk_app_target)
  end

  it 'should have proper wk ext target' do
    expect(@sut.wk_ext_target).to eq(@wk_ext_target)
  end

  it 'should have proper scheme name' do
    expect(@sut.app_scheme_name).to eq('fixtureScheme')
  end

  it 'should have proper app scheme' do
    expect(@sut.app_scheme).to eq(@spy_scheme)
  end
end
