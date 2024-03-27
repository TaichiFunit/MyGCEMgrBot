require './lib/api_base.rb'

class GCEInstance < APIBase
  def initialize project_id: ENV['PROJECT_ID'], zone: ENV['ZONE'], instance_id: ENV['INSTANCE_ID']
    @project_id = project_id
    @zone = zone
    @instance_id = instance_id
  end

  def get
    # https://cloud.google.com/compute/docs/reference/rest/v1/instances/get
    res = http_get api_endpoint
    res[:body]
  end

  def start
    # https://cloud.google.com/compute/docs/reference/rest/v1/instances/start
    res = http_post(api_endpoint + '/start')
    res[:code]
  end

  def stop
    # https://cloud.google.com/compute/docs/reference/rest/v1/instances/stop
    res = http_post(api_endpoint + '/stop')
    res[:code]
  end

  private

  def api_endpoint
    "https://compute.googleapis.com/compute/v1/projects/#{@project_id}/zones/#{@zone}/instances/#{@instance_id}"
  end
end
