require 'rspec'
require 'rswift'

describe RSwift::AttributesConfigurator do

  before do
    @sut = RSwift::AttributesConfigurator.new
  end

  after do
    @sut = nil
  end

  describe 'configure project attributes' do

    before do
      @spy_root_object = spy(attributes: {'fixture initial attribute' => 'fixture initial value'})
      @spy_project = spy(root_object: @spy_root_object,
      spec_target: spy(uuid: 'fixture spec target uuid'),
      app_target: spy(uuid: 'fixture app target uuid'))
      @sut.configure_project_attributes @spy_project
    end

    it 'should have proper attributes' do
      expected_attributes = { 'fixture initial attribute' => 'fixture initial value',
        'TargetAttributes' => {
          'fixture spec target uuid' => {
            'TestTargetID' => 'fixture app target uuid'
          }
        }
      }
      expect(@spy_root_object.attributes).to eq(expected_attributes)
    end
  end
end
