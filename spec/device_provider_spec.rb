require 'rspec'
require 'rswift'

describe RSwift::DeviceProvider do

  describe 'udid for device' do

    before do
      fixture_devices = %({"devices" : {"os 1.2" : [{"name" : "fixture device", "udid" : "fixture udid"}]}})
      allow(RSwift::DeviceProvider).to receive(:`).with("xcrun simctl list devices -j").and_return(fixture_devices)
      stub_const("RSwift::Constants::TEMPLATE_PROPERTIES", {template: {sdk: 'os 1.2'}})
      @udid = RSwift::DeviceProvider.udid_for_device('fixture device', :template)
    end

    it 'should return proper udid' do
      expect(@udid).to eq('fixture udid')
    end
  end
end
