require 'rspec'
require 'rswift'

describe RSwift::BuildSettingsConfigurator do

  before do
    @sut = RSwift::BuildSettingsConfigurator.new
  end

  after do
    @sut = nil
  end

  it 'should have build settings provider' do
    expect(@sut.build_settings_provider).to be_a_kind_of(RSwift::BuildSettingsProvider)
  end

  describe 'configure project settings' do

    before do
      @spy_debug_build_configuration = spy(build_settings: {initialDebugBuildConfiguration: 'initialDebugBuildConfiguration'})
      @spy_release_build_configuration = spy(build_settings: {initialReleaseBuildConfiguration: 'initialReleaseBuildConfiguration'})
      @spy_project = spy(debug_build_configuration: @spy_debug_build_configuration, release_build_configuration: @spy_release_build_configuration)
      @spy_build_settings_provider = spy(project_debug_settings: {fixtureProjectDebugSettings: 'fixtureProjectDebugSettings'}, project_release_settings: {fixtureProjectReleaseSettings: 'fixtureProjectReleaseSettings'})
      @sut.build_settings_provider = @spy_build_settings_provider
      @sut.configure_project_settings(@spy_project, :template)
    end

    it 'should set proper project debug build settings' do
      expect(@spy_debug_build_configuration.build_settings).to eq({initialDebugBuildConfiguration: 'initialDebugBuildConfiguration', fixtureProjectDebugSettings: 'fixtureProjectDebugSettings'})
    end

    it 'should set proper project release build settings' do
      expect(@spy_release_build_configuration.build_settings).to eq({initialReleaseBuildConfiguration: 'initialReleaseBuildConfiguration', fixtureProjectReleaseSettings: 'fixtureProjectReleaseSettings'})
    end
  end

  describe 'configure target settings' do

    before do
      @spy_debug_build_configuration = spy(build_settings: {initialDebugBuildConfiguration: 'initialDebugBuildConfiguration'})
      @spy_release_build_configuration = spy(build_settings: {initialReleaseBuildConfiguration: 'initialReleaseBuildConfiguration'})
      @spy_project = spy
      @spy_target = spy(debug_build_configuration: @spy_debug_build_configuration, release_build_configuration: @spy_release_build_configuration)
      @spy_build_settings_provider = spy(target_debug_settings: {fixtureTargetDebugSettings: 'fixtureTargetDebugSettings'}, target_release_settings: {fixtureTargetReleaseSettings: 'fixtureTargetReleaseSettings'})
      @sut.build_settings_provider = @spy_build_settings_provider
      @sut.configure_target_settings(@spy_project, @spy_target, :template)
    end

    it 'should set proper project debug build settings' do
      expect(@spy_debug_build_configuration.build_settings).to eq({initialDebugBuildConfiguration: 'initialDebugBuildConfiguration', fixtureTargetDebugSettings: 'fixtureTargetDebugSettings'})
    end

    it 'should set proper project release build settings' do
      expect(@spy_release_build_configuration.build_settings).to eq({initialReleaseBuildConfiguration: 'initialReleaseBuildConfiguration', fixtureTargetReleaseSettings: 'fixtureTargetReleaseSettings'})
    end
  end
end
