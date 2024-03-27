require 'net/http'
require 'uri'
require 'json'

class GCEInstance
  def initialize project_id:, zone:, instance_id: 
    @project_id = project_id
    @zone = zone
    @instance_id = instance_id
  end

  def status
    # https://cloud.google.com/compute/docs/reference/rest/v1/instances/get
    res = http_get api_endpoint
    res[:body]['status']
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

  def fetch_access_token
    `gcloud auth print-access-token`.strip
  end

  def api_endpoint
    "https://compute.googleapis.com/compute/v1/projects/#{@project_id}/zones/#{@zone}/instances/#{@instance_id}"
  end

  def http(klass, uri)
    uri = URI.parse uri
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    req = klass.new uri.path

    req['Authorization'] = "Bearer #{fetch_access_token}"
    req['Content-Type'] = 'application/json'

    res = https.request req
    { code: res.code, body: JSON.parse(res.body) }
  end

  def http_get(uri)
    http Net::HTTP::Get, uri
  end

  def http_post(uri)
    http Net::HTTP::Post, uri
  end
end
