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

  def disk
    Disk.new(project_id: @project_id, zone: @zone, disk_id: self.get['disks'].first['deviceName'])
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

class Disk < APIBase
  def initialize project_id:, zone: disk_id:
    @project_id = project_id
    @zone = zone
    @disk_id = disk_id
  end

  # https://cloud.google.com/compute/docs/reference/rest/v1/disks/createSnapshot
  def create_snapshot
    res = http_post(api_endpoint + '/createSnapshot')
  end

  def api_endpoint
    "https://compute.googleapis.com/compute/v1/projects/#{@project_id}/zones/#{@zone}/disks/#{@disk_id}"
  end
end

class Snapshot < APIBase
  def initialize project_id:
    @project_id = project_id
  end

  # https://cloud.google.com/compute/docs/reference/rest/v1/snapshots/insert
  def create_snapshot(name: nil, disk_id:, locations:)
    params = {
      name: name || "snapshot-#{@disk_id}-#{Time.now.strftime('%Y%m%d_%H%M%S')}",
      sourceDisk: disk_id,
      storageLocations: locations,
    }

    http_post api_endpoint, params: params
  end

  private

  def api_endpoint
    "https://compute.googleapis.com/compute/v1/projects/#{@project_id}/global/snapshots"
  end
end
