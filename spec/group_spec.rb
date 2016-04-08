require 'rspec'
require 'rswift'

describe Xcodeproj::Project::Object::PBXGroup do

  before do
    project = Xcodeproj::Project.new('fixture/project/path')
    @sut = project.new_group('fixture/group')
  end

  after do
    @sut = nil
  end

  describe 'file for path' do

    context 'when file for path does not exist' do

      before do
        @sut.clear
        @file = @sut.file_for_path('fixture/path')
      end

      it 'should have 1 file' do
        expect(@sut.files.count).to eq(1)
      end

      it 'should return created file' do
        expect(@file).to be_a_kind_of(Xcodeproj::Project::Object::PBXFileReference)
      end
    end

    context 'when file for path exists' do

      before do
        @previously_created_file = @sut.new_file('fixture/path')
        @file = @sut.file_for_path('fixture/path')
      end

      it 'should have 1 file' do
        expect(@sut.files.count).to eq(1)
      end

      it 'should return previously created file' do
        expect(@file).to eq(@previously_created_file)
      end
    end
  end

  describe 'group for path' do

    context 'when group for path does not exist' do

      before do
        @sut.clear
        @group = @sut.group_for_path('fixture/path')
      end

      it 'should have 1 group' do
        expect(@sut.groups.count).to eq(1)
      end

      it 'should return created group' do
        expect(@group).to be_a_kind_of(Xcodeproj::Project::Object::PBXGroup)
      end
    end

    context 'when group for path exists' do

      before do
        @previously_created_group = @sut.new_group('fixture/path', 'fixture/path')
        @group = @sut.group_for_path('fixture/path')
      end

      it 'should have 1 group' do
        expect(@sut.groups.count).to eq(1)
      end

      it 'should return previously created group' do
        expect(@group).to eq(@previously_created_group)
      end
    end
  end
end
