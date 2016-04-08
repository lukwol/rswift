require 'rspec'
require 'rswift'

describe RSwift::BuildSettingsProvider do

  before do
    @sut = RSwift::BuildSettingsProvider.new
  end

  after do
    @sut = nil
  end

  describe 'project debug settings' do

    before do
      @settings = @sut.project_debug_settings(:ios)
    end

    it 'should return proper settings' do
      expect(@settings).to eq({'ENABLE_TESTABILITY' => 'YES'})
    end
  end

  describe 'project release settings' do

    before do
      @settings = @sut.project_release_settings(:ios)
    end

    it 'should return proper settings' do
      expect(@settings).to eq({})
    end
  end

  describe 'target debug settings' do

    before do
      @spy_project = spy(app_target: spy(name: 'fixtureAppTargetName'))
      @spy_target = spy(name: 'fixtureTargetName', group_name: 'fixtureGroupName', product_type_uti: :unit_test_bundle)
      @settings = @sut.target_debug_settings(@spy_project, @spy_target, :ios)
    end

    it 'should return proper settings' do
      expected_settings = {
        'INFOPLIST_FILE' => 'fixtureGroupName/Info.plist',
        'TARGETED_DEVICE_FAMILY' => '1,2',
        'PRODUCT_BUNDLE_IDENTIFIER' => 'com.rswift.fixtureTargetName',
        'BUNDLE_LOADER' => '$(TEST_HOST)',
        'TEST_HOST' => '$(BUILT_PRODUCTS_DIR)/fixtureAppTargetName.app/fixtureAppTargetName'
      }
      expect(@settings).to eq(expected_settings)
    end
  end

  describe 'target release settings' do

    before do
      @spy_project = spy(app_target: spy(name: 'fixtureAppTargetName'))
      @spy_target = spy(name: 'fixtureTargetName', group_name: 'fixtureGroupName', product_type_uti: :application)
      @settings = @sut.target_debug_settings(@spy_project, @spy_target, :ios)
    end

    it 'should return proper settings' do
      expected_settings = {
        'INFOPLIST_FILE' => 'fixtureGroupName/Info.plist',
        'TARGETED_DEVICE_FAMILY' => '1,2',
        'PRODUCT_BUNDLE_IDENTIFIER' => 'com.rswift.fixtureTargetName'
      }
      expect(@settings).to eq(expected_settings)
      end
    end
  end
