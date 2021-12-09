class ProcessEventsWorker
  include Sidekiq::Worker

  def perform(slug)
    ProcessCollectionEventsWorker.perform_async(slug, 'created')
    ProcessCollectionEventsWorker.perform_async(slug, 'successful')
    ProcessCollectionEventsWorker.perform_async(slug, 'cancelled')
  end
end
