require 'net/http'
require 'uri'
require 'json'

class Server
  def initialize endpoints: {}
    @action_endpoints = {
      status: endpoints[:status] || ENV['STATUS_ENDPOINT'],
      invoke: endpoints[:invoke] || ENV['INVOKE_ENDPOINT'],
      stop: endpoints[:stop] || ENV['STOP_ENDPOINT'],
    }

  end

  def invoke
    self.http_post @action_endpoints[:invoke]
  end

  def stop
    self.http_post @action_endpoints[:stop]
  end

  def status
    res = self.http_get @action_endpoints[:status]
    JSON.parse(res.body)['status']
  end

  private

  def fetch_access_token
    `gcloud auth print-access-token`.strip
  end

  def http(klass, uri)
    uri = URI.parse uri
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    req = klass.new uri.path

    req['Authorization'] = "Bearer #{fetch_access_token}"
    req['Content-Type'] = 'application/json'

    https.request req
  end

  def http_get(uri)
    self.http Net::HTTP::Get, uri
  end

  def http_post(uri)
    self.http Net::HTTP::Post, uri
  end
end
