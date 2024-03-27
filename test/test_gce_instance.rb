require 'minitest/autorun'
require './lib/gce_instance.rb'
require 'dotenv'

Dotenv.load('./.env')

PROJECT_ID = ENV['PROJECT_ID']
ZONE = ENV['ZONE']
INSTANCE_ID = ENV['INSTANCE_ID']

describe GCEInstance do
  before do
    @instance = GCEInstance.new project_id: PROJECT_ID, zone: ZONE, instance_id: INSTANCE_ID
  end

  describe '#status' do
    it 'must have valid status' do
      VALID_STATUS = %w(PROVISIONING STAGING RUNNING STOPPING SUSPENDING SUSPENDED REPAIRING TERMINATED)
      assert_includes VALID_STATUS, @instance.get['status']
    end
  end

  describe '#backup' do
    it 'must success' do
#      @instnace.disk.backup
    end
  end
end
