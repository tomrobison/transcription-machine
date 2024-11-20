class Bunny
  attr_reader :client

  def self.sync
    new.sync
  end

  def initialize(library_id: nil, access_key: nil)
    library_id ||= 341522
    access_key ||= ENV["BUNNY_ACCESS_KEY"]

    @client = BunnyClient.new(library_id: library_id, access_key: access_key)
  end

  def sync(page: 1)
    loop do
      response = client.get("/videolibrary?page=#{page}")

      response["Items"].each { sync_video(_1) }

      break unless response["HasMoreItems"]
      page += 1
    end
  end

  def sync_video(item)
    video = Video.where(guid: item["Id"]).first_or_initialize
    video.update(
      # library_id: item[:videoLibraryId],
      title: item["Name"],
      # captions: item[:captions].any?{_1[:label] == "English" }
    )
  end
end