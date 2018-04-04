class ShogunHarvestWorker
  include Sidekiq::Worker

  def perform(catalog_url)
    ShogunService.harvest(catalog_url)
  end

  def updateorg(catalog_url)
    ShogunService.updateorg(oldname, newname)
  end

end
