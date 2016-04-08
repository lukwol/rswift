require 'rspec'
require 'rswift'

describe RSwift::GroupReferencesManager do

  before do
    @spy_file_reference = spy
    @spy_version_group = spy(path: 'fixture.xcdatamodeld')
    @spy_group_reference = spy
    @spy_group = spy(
      real_path: Pathname.new('fixture/path'),
      file_for_path: @spy_file_reference,
      group_for_path: @spy_group_reference,
      version_groups: [@spy_version_group]
      )
    @spy_files_references_manager = spy
    @spy_source_build_phase = spy
    @spy_resources_build_phase = spy
    @spy_target = spy(source_build_phase: @spy_source_build_phase, resources_build_phase: @spy_resources_build_phase)
    @sut = RSwift::GroupReferencesManager.new(@spy_files_references_manager)
  end

  after do
    @sut = nil
  end

  describe 'update files references' do

    before do
      allow(File).to receive(:file?).and_return(true)
    end

    context 'when file is Info.plist' do

      before do
        allow(Dir).to receive(:glob).with('fixture/path/*').and_return(['Info.plist'])
        @sut.update_files_references(@spy_group, @spy_target)
      end

      it 'should add file reference to group' do
        expect(@spy_group).to have_received(:file_for_path).with('Info.plist')
      end
    end

    context 'when file is xcdatamodel' do

      before do
        allow(Dir).to receive(:glob).with('fixture/path/*').and_return(['test.xcdatamodel'])
        @sut.update_files_references(@spy_group, @spy_target)
      end

      it 'should add file reference to group' do
        expect(@spy_group).to have_received(:file_for_path).with('test.xcdatamodel')
      end
    end

    context 'when file is compile source' do

      before do
        allow(Dir).to receive(:glob).with('fixture/path/*').and_return(['fixture.swift'])
        @sut.update_files_references(@spy_group, @spy_target)
      end

      it 'should add file reference to group' do
        expect(@spy_group).to have_received(:file_for_path).with('fixture.swift')
      end

      it 'should add file reference to source build phase' do
        expect(@spy_source_build_phase).to have_received(:add_file_reference).with(@spy_file_reference, true)
      end
    end

    context 'when file is resource' do

      before do
        allow(Dir).to receive(:glob).with('fixture/path/*').and_return(['fixture.storyboard'])
        @sut.update_files_references(@spy_group, @spy_target)
      end

      it 'should add file reference to group' do
        expect(@spy_group).to have_received(:file_for_path).with('fixture.storyboard')
      end

      it 'should add file reference to resources build phase' do
        expect(@spy_resources_build_phase).to have_received(:add_file_reference).with(@spy_file_reference, true)
      end
    end
  end

  describe 'update directory references' do

    before do
      allow(File).to receive(:file?).and_return(false)
    end

    context 'when directory is compile source' do

      before do
        allow(Dir).to receive(:glob).with('fixture/path/*').and_return(['fixture.xcmappingmodel'])
        @sut.update_directory_references(@spy_group, @spy_target)
      end

      it 'should add directory reference to group' do
        expect(@spy_group).to have_received(:file_for_path).with('fixture.xcmappingmodel')
      end

      it 'should add directory reference to source build phase' do
        expect(@spy_source_build_phase).to have_received(:add_file_reference).with(@spy_file_reference, true)
      end
    end

    context 'when directory is resource' do

      before do
        allow(Dir).to receive(:glob).with('fixture/path/*').and_return(['fixture.xcassets'])
        @sut.update_directory_references(@spy_group, @spy_target)
      end

      it 'should add directory reference to group' do
        expect(@spy_group).to have_received(:file_for_path).with('fixture.xcassets')
      end

      it 'should add directory reference to resources build phase' do
        expect(@spy_resources_build_phase).to have_received(:add_file_reference).with(@spy_file_reference, true)
      end
    end

    context 'when directory is simple directory with files' do

      before do
        allow(Dir).to receive(:glob).with('fixture/path/*').and_return(['fixtureDirectory'])
        @sut.update_directory_references(@spy_group, @spy_target)
      end

      it 'should add new group reference to group' do
        expect(@spy_group).to have_received(:group_for_path).with('fixtureDirectory')
      end

      it 'should update group references with new group reference' do
        expect(@spy_files_references_manager).to have_received(:update_target_references).with(@spy_group_reference, @spy_target)
      end
    end
  end

  describe 'cleanup invalid references' do

    before do
      @spy_valid_compile_source = spy(path: 'valid.swift')
      @spy_invalid_compile_source = spy(path: 'invalid.swift')
      @spy_valid_resource = spy(path: 'valid.storyboard')
      @spy_invalid_resource = spy(path: 'invalid.storyboard')
      @spy_valid_file = spy(path: 'valid_file')
      @spy_invalid_file = spy(path: 'invalid_file')
      @spy_valid_group = spy(path: 'valid_group')
      @spy_invalid_group = spy(path: 'invalid_group')
      allow(@spy_group).to receive(:files).and_return([@spy_valid_compile_source,
        @spy_invalid_compile_source,
        @spy_valid_resource,
        @spy_invalid_resource,
        @spy_valid_file,
        @spy_invalid_file])
      allow(@spy_group).to receive(:groups).and_return([@spy_valid_group, @spy_invalid_group])
      allow(Dir).to receive(:glob).with('fixture/path/*').and_return(%w(valid.swift valid.storyboard valid_file valid_group))
      allow(File).to receive(:file?).with('valid_file').and_return(true)
      allow(File).to receive(:file?).with('invalid_file').and_return(true)
      allow(File).to receive(:file?).with('valid_group').and_return(false)
      allow(File).to receive(:file?).with('invalid_group').and_return(false)
      @sut.cleanup_invalid_references(@spy_group)
    end

    it 'should remove invalid compile source from project' do
      expect(@spy_invalid_compile_source).to have_received(:remove_from_project)
    end

    it 'should not remove valid compile source from project' do
      expect(@spy_valid_compile_source).to_not have_received(:remove_from_project)
    end

    it 'should remove invalid resource from project' do
      expect(@spy_invalid_resource).to have_received(:remove_from_project)
    end

    it 'should not remove valid compile source from project' do
      expect(@spy_valid_resource).to_not have_received(:remove_from_project)
    end

    it 'should remove invalid file from project' do
      expect(@spy_invalid_file).to have_received(:remove_from_project)
    end

    it 'should not remove valid file from project' do
      expect(@spy_valid_file).to_not have_received(:remove_from_project)
    end

    it 'should remove invalid group from project' do
      expect(@spy_invalid_group).to have_received(:remove_from_project)
    end

    it 'should clear invalid group' do
      expect(@spy_invalid_group).to have_received(:clear)
    end

    it 'should not remove valid group from project' do
      expect(@spy_valid_group).to_not have_received(:remove_from_project)
    end

    it 'should not clear invalid group' do
      expect(@spy_valid_group).to_not have_received(:clear)
    end
  end

  describe 'cleanup build files' do

    before do
      @spy_invalid_build_source = spy(file_ref: nil)
      @spy_valid_build_source = spy(file_ref: @spy_file_reference)
      @spy_invalid_resource = spy(file_ref: nil)
      @spy_valid_resource = spy(file_ref: @spy_file_reference)
      allow(@spy_source_build_phase).to receive(:files).and_return([@spy_invalid_build_source, @spy_valid_build_source])
      allow(@spy_resources_build_phase).to receive(:files).and_return([@spy_invalid_resource, @spy_valid_resource])
      @sut.cleanup_build_files(@spy_target)
    end

    it 'should remove invalid build source' do
      expect(@spy_source_build_phase).to have_received(:remove_build_file).with(@spy_invalid_build_source)
    end

    it 'should not remove invalid build source' do
      expect(@spy_source_build_phase).to_not have_received(:remove_build_file).with(@spy_valid_build_source)
    end

    it 'should remove invalid resource' do
      expect(@spy_resources_build_phase).to have_received(:remove_build_file).with(@spy_invalid_resource)
    end

    it 'should not remove invalid build source' do
      expect(@spy_resources_build_phase).to_not have_received(:remove_build_file).with(@spy_valid_resource)
    end
  end
end
