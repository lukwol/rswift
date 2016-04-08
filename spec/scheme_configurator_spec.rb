require 'rspec'
require 'rswift'

describe RSwift::SchemeConfigurator do

  describe 'create app scheme' do

    before do
      @sut = RSwift::SchemeConfigurator.new
    end

    after do
      @sut = nil
    end

    describe 'create app scheme' do

      before do
        @spy_scheme = spy
        @spy_app_target = spy
        @spy_spec_target = spy
        @spy_project = spy(name: 'fixtureName',
                           path: 'fixturePath',
                           scheme: @spy_scheme,
                           app_target: @spy_app_target,
                           spec_target: @spy_spec_target)
        @sut.configure_app_scheme(@spy_project, @spy_scheme)
      end

      it 'should add build target' do
        expect(@spy_scheme).to have_received(:add_build_target).with(@spy_app_target)
      end

      it 'should set launch target' do
        expect(@spy_scheme).to have_received(:set_launch_target).with(@spy_app_target)
      end

      it 'should add test target' do
        expect(@spy_scheme).to have_received(:add_test_target).with(@spy_spec_target)
      end

      it 'should save scheme' do
        expect(@spy_scheme).to have_received(:save_as).with('fixturePath', 'fixtureName')
      end
    end
  end
end
