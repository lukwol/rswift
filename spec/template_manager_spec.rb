require 'rspec'
require 'rswift'

describe RSwift::TemplateManager do

  before do
    @sut = RSwift::TemplateManager.new
  end

  after do
    @sut = nil
  end

  describe 'source root' do

    before do
      allow(File).to receive(:dirname).and_return('fixture_dirname')
      @source_root = RSwift::TemplateManager.source_root
    end

    it 'should have proper source root path' do
      expect(@source_root).to eq('fixture_dirname')
    end
  end

  describe 'create files for template' do

    before do
      allow(@sut).to receive(:template)
      allow(File).to receive(:dirname).and_return('fixture_dirname')
      allow(Dir).to receive(:glob).with('fixture_dirname/templates/app/ios/**/*.erb', File::FNM_DOTMATCH).and_return(['fixture_ios_file.erb'])
      @sut.create_files_for_template('FixtureProjectName', :ios)
    end

    it 'should create file using proper template' do
      expect(@sut).to have_received(:template).with('fixture_ios_file.erb', 'FixtureProjectName/fixture_dirname/fixture_ios_file')
    end
  end
end
