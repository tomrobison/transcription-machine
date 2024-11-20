class Bunny
  attr_reader :client

  def initialize(library_id: nil, access_key: nil)
    library_id ||= Rails.application.credentials.bunny_library_id 
    access_key ||= Rails.application.credentials.bunny_access_key

    @client = BunnyClient.new(library_id: library_id, access_key: access_key)
  end

  def sync(page: 1)
    loop do
      response = client.get("/videolibrary?page=#{page}")
      require 'pry'; binding.pry
      response[:items].each { sync_video(_1) }

      next_page response[:current_page] * response[:itemsPerPage] < response[:total_items]
      page += 1
    end
  end

  def sync_video(item)
    video = Video.where(guid: item[:guid]).first_or_initialize
    video.update(
      library_id: item[:videoLibraryId],
      title: item[:title],
      captions: item[:captions].any?{_1[:label] == "English" }
    )
  end
end