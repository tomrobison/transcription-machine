require 'net/http'

class BunnyClient::V0
  BASE_URI = "https://video.bunnycdn.com"

  def initialize(library_id:, access_key:)
    @library_id, @access_key = library_id, access_key
  end

  def get(path)
    http_request(Net::HTTP::Get, "#{path}")
  end

  def post(path, body:)
    http_request(Net::HTTP::Post, "#{path}", body: body)
  end

  private

  # http_request(Net::HTTP::Post, "/videos", body: {})
  def http_request(method, path, body: nil)
    uri = URI.parse("#{BASE_URI}#{path}")

    http = Net::HTTP.new(uri.host, uri.path)
    http.use_ssl = uri.is_a?(URI::HTTPS)

    request = method.new(uri)
    request["accept"] = "application/json"
    request["AccessKey"] = @access_key

    if request.is_a? Net::HTTP::Post
      request.body = body.to_json
      request.body["content-type"] = "application/json"
    end

    response = http.request(request)

    if response.is_a? Net::HTTPSuccess
      JSON.parse(response.body).with_indifferent_access
    else
      binding.pry
      raise StandardError, "Request failed."
    end
  end
end