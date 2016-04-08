require 'rspec'
require 'rswift'

describe RSwift::TargetConfigurator do

  before do
    @sut = RSwift::TargetConfigurator.new
  end

  after do
    @sut = nil
  end

  it 'should have build settings configurator' do
    expect(@sut.build_settings_configurator).to be_a_kind_of(RSwift::BuildSettingsConfigurator)
  end

  it 'should have files references manager' do
    expect(@sut.files_references_manager).to be_a_kind_of(RSwift::FilesReferencesManager)
  end

  describe 'configure target' do

    before do
      @spy_project = spy
      @spy_group = spy
      allow(@spy_project).to receive(:new_group).with('FixtureGroupName', 'FixtureGroupName').and_return(@spy_group)
      @spy_target = spy(group_name: 'FixtureGroupName')
      @spy_build_settings_configurator = spy
      @sut.build_settings_configurator = @spy_build_settings_configurator
      @spy_files_references_manager = spy
      @sut.files_references_manager = @spy_files_references_manager
      @sut.configure_target(@spy_project, @spy_target, :fixture_template)
    end

    it 'should configure target settings' do
      expect(@spy_build_settings_configurator).to have_received(:configure_target_settings).with(@spy_project, @spy_target, :fixture_template)
    end

    it 'should update target references' do
      expect(@spy_files_references_manager).to have_received(:update_target_references).with(@spy_group, @spy_target)
    end
  end

  describe 'configure targets dependencies' do

    before do
      @spy_app_target = spy
      @spy_spect_target = spy
      @spy_project = spy(app_target: @spy_app_target, spec_target: @spy_spect_target)
      @sut.configure_targets_dependencies(@spy_project)
    end

    it 'should add app target dependency to spec target' do
      expect(@spy_spect_target).to have_received(:add_dependency).with(@spy_app_target)
    end
  end
end
