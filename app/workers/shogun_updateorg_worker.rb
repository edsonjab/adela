class ShogunUpdateorgWorker
  include Sidekiq::Worker

  def perform(oldname, newname, newtitle)
    ShogunService.updateorg(oldname, newname, newtitle)
  end

end
