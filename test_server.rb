require 'minitest/autorun'
require './server.rb'

describe Server do
  before do
    require 'dotenv'

    Dotenv.load('./.env')
    @server = Server.new
  end

  describe '#status' do
    it 'must have valid status' do
      VALID_STATUS = %w(PROVISIONING STAGING RUNNING STOPPING SUSPENDING SUSPENDED REPAIRING TERMINATED)
      assert_includes VALID_STATUS, @server.status
    end
  end
end
