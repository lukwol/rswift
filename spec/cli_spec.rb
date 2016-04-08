require 'rspec'
require 'rswift'

describe RSwift::CLI do

  before do
    @sut = RSwift::CLI.new
  end

  after do
    @sut = nil
  end

  it 'should have template manager' do
    expect(@sut.template_manager).to be_a_kind_of(RSwift::TemplateManager)
  end

  it 'should have project configurator' do
    expect(@sut.project_configurator).to be_a_kind_of(RSwift::ProjectConfigurator)
  end

  describe 'app' do

    before do
      @spy_template_manager = spy
      @sut.template_manager = @spy_template_manager

      @spy_project_configurator = spy
      allow(@spy_project_configurator).to receive(:configure_project) do |project, _|
        @captured_project = project
      end
      @sut.project_configurator = @spy_project_configurator
      allow_any_instance_of(Xcodeproj::Project).to receive(:save) do
        @did_save_project = true
      end
      allow(@sut).to receive(:say_status)
    end

    context 'when user does not specify template' do

      before do
        @sut.options = {}
        @sut.app('FixtureProjectName')
      end

      it 'should create create files for ios template' do
        expect(@spy_template_manager).to have_received(:create_files_for_template).with('FixtureProjectName', :ios)
      end

      it 'should create project with proper path' do
        expect(@captured_project.path.to_path).to eq(File.expand_path('FixtureProjectName/FixtureProjectName.xcodeproj'))
      end

      it 'should configure created project with ios template' do
        expect(@spy_project_configurator).to have_received(:configure_project).with(kind_of(Xcodeproj::Project), :ios)
      end

      it 'should save created project' do
        expect(@did_save_project).to be_truthy
      end

      it 'should print proper output' do
        expect(@sut).to have_received(:say_status).with(:generate, 'FixtureProjectName/FixtureProjectName.xcodeproj')
      end
    end

    context 'when user specifies template' do

      before do
        @sut.options = {template: :osx}
        @sut.app('FixtureProjectName')
      end

      it 'should create create files for osx template' do
        expect(@spy_template_manager).to have_received(:create_files_for_template).with('FixtureProjectName', :osx)
      end

      it 'should create project with proper path' do
        expect(@captured_project.path.to_path).to eq(File.expand_path('FixtureProjectName/FixtureProjectName.xcodeproj'))
      end

      it 'should configure created project with osx template' do
        expect(@spy_project_configurator).to have_received(:configure_project).with(kind_of(Xcodeproj::Project), :osx)
      end

      it 'should print proper output' do
        expect(@sut).to have_received(:say_status).with(:generate, 'FixtureProjectName/FixtureProjectName.xcodeproj')
      end
    end
  end
end
