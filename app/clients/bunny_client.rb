class BunnyClient
  include HTTParty

  base_uri 'api.bunny.net'

  def initialize(library_id:, access_key:)
    @library_id, @access_key = library_id, access_key
  end

  def get(path)
    self.class.get(path, headers: headers)
  end

  def post(path, body:)
    self.class.post(path, body: body, headers: headers)
  end

  private

  def headers
    {
      'Content-Type' => 'application/json',
      'AccessKey' => @access_key
    }
  end
end