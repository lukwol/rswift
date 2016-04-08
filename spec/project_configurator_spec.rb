require 'rspec'
require 'rswift'

describe RSwift::ProjectConfigurator do

  before do
    @sut = RSwift::ProjectConfigurator.new
  end

  after do
    @sut = nil
  end

  it 'should have build settings provider' do
    expect(@sut.build_settings_configurator).to be_a_kind_of(RSwift::BuildSettingsConfigurator)
  end

  it 'should have target configurator' do
    expect(@sut.target_configurator).to be_a_kind_of(RSwift::TargetConfigurator)
  end

  it 'should have attributes configurator' do
    expect(@sut.attributes_configurator).to be_a_kind_of(RSwift::AttributesConfigurator)
  end

  it 'should have scheme configurator' do
    expect(@sut.scheme_configurator).to be_a_kind_of(RSwift::SchemeConfigurator)
  end

  describe 'configure project' do

    before do
      @spy_project = spy(name: 'FixtureProjectName')
      @spy_target = spy
      allow(@spy_project).to receive(:new_target).with(:application, 'FixtureProjectName fixture suffix', :fixture_template).and_return(@spy_target)
      @spy_target_configurator = spy
      @sut.target_configurator = @spy_target_configurator
      stub_const("RSwift::Constants::TEMPLATE_PROPERTIES", {fixture_template: {target_types: [:application]}})
      stub_const("RSwift::Constants::TARGET_PROPERTIES", {application: {group_name: 'fixture group name', suffix: ' fixture suffix'}})
      @spy_scheme_configurator = spy
      @sut.scheme_configurator = @spy_scheme_configurator
      @spy_build_settings_configurator = spy
      @sut.build_settings_configurator = @spy_build_settings_configurator
      @spy_attributes_configurator = spy
      @sut.attributes_configurator = @spy_attributes_configurator
      @sut.configure_project(@spy_project, :fixture_template)
    end

    it 'should configure target for target types' do
      expect(@spy_target_configurator).to have_received(:configure_target).with(@spy_project, @spy_target, :fixture_template)
    end

    it 'should configure targets dependencies' do
      expect(@spy_target_configurator).to have_received(:configure_targets_dependencies).with(@spy_project)
    end

    it 'should configure app scheme' do
      expect(@spy_scheme_configurator).to have_received(:configure_app_scheme).with(@spy_project, instance_of(Xcodeproj::XCScheme))
    end

    it 'should configure project settings' do
      expect(@spy_build_settings_configurator).to have_received(:configure_project_settings).with(@spy_project, :fixture_template)
    end

    it 'should configure project attributes' do
      expect(@spy_attributes_configurator).to have_received(:configure_project_attributes).with(@spy_project)
    end
  end
end
