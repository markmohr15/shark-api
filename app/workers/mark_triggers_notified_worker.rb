class MarkTriggersNotifiedWorker
  include Sidekiq::Worker

  def perform(ids)
    triggers = Trigger.where id: ids
    triggers.update_all notified: true
  end
end
