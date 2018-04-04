class ShogunHarvestWorker
  include Sidekiq::Worker

  def perform(catalog_url)
    ShogunService.harvest(catalog_url)
  end

  def updateorg(oldname, newname)
    ShogunService.updateorg(oldname, newname)
  end

end
