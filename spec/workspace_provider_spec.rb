require 'rspec'
require 'rswift'

describe RSwift::WorkspaceProvider do

  describe 'workspace' do

    context 'when there is workspace' do

      before do
        allow(Dir).to receive(:glob).with(['*.xcworkspace']).and_return(['fixture.xcworkspace'])
        @workspace = RSwift::WorkspaceProvider.workspace
      end

      it 'should return workspace' do
        expect(@workspace).to eq('fixture.xcworkspace')
      end
    end

    context 'when there is no workspace' do

      before do
        allow_any_instance_of(Kernel).to receive(:raise) { |message| @captured_message = message }
        allow(Dir).to receive(:glob).with(['*.xcworkspace']).and_return([])
        @workspace = RSwift::WorkspaceProvider.workspace
      end
      
      it 'should raise exception with proper message' do
        expect(@captured_message).to eq("xcworkspace not found, did you install pods?")
      end

      it 'should return nil' do
        expect(@workspace).to be_nil
      end
    end
  end
end
