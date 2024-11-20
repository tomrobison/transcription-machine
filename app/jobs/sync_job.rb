class SyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Bunny.sync
  end
end