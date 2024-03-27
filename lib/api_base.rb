require 'net/http'
require 'uri'
require 'json'

class APIBase
  protected

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
