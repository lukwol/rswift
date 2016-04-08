require 'rspec'
require 'rswift'

describe RSwift::FilesReferencesManager do

  before do
    @sut = RSwift::FilesReferencesManager.new
  end

  after do
    @sut = nil
  end

  describe 'group references manager' do

    before do
      @group_references_manager = @sut.group_references_manager
    end

    it 'should be group references manager' do
      expect(@group_references_manager).to be_a_kind_of(RSwift::GroupReferencesManager)
    end

    it 'should have files references manager' do
      expect(@group_references_manager.files_references_manager).to eq(@sut)
    end
  end

  describe 'update target references' do

    before do
      @spy_group = spy
      @spy_target = spy
      @spy_group_references_manager = spy
      @sut.group_references_manager = @spy_group_references_manager
      @sut.update_target_references(@spy_group, @spy_target)
    end

    it 'should cleanup invalid references' do
      expect(@spy_group_references_manager).to have_received(:cleanup_invalid_references).with(@spy_group)
    end

    it 'should update files references' do
      expect(@spy_group_references_manager).to have_received(:update_files_references).with(@spy_group, @spy_target)
    end

    it 'should update directory references' do
      expect(@spy_group_references_manager).to have_received(:update_directory_references).with(@spy_group, @spy_target)
    end

    it 'should cleanup build files' do
      expect(@spy_group_references_manager).to have_received(:cleanup_build_files).with(@spy_target)
    end
  end
end
