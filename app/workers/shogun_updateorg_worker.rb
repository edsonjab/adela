class ShogunUpdateorgWorker
  include Sidekiq::Worker

  def perform(oldname, newname)
    ShogunService.updateorg(oldname, newname)
  end

end
