require 'json'

module RSwift
  class DeviceProvider

    def self.udid_for_device(device_name, template)
      devices = devices_for_template(template)
      devices[device_name].udid
    end

    private

    def self.devices_for_template(template)
      devices_json = `xcrun simctl list devices -j`
      devices = JSON.parse(devices_json)['devices']
      sdk = RSwift::Constants::TEMPLATE_PROPERTIES[template][:sdk]
      devices_for_sdk = {}
      devices[sdk].each do |device_hash|
        device = OpenStruct.new(device_hash)
        devices_for_sdk[device.name] = device
      end
      devices_for_sdk
    end
  end
end
