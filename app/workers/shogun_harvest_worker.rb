class ShogunHarvestWorker
  include Sidekiq::Worker

  def perform(catalog_url)
    ShogunService.harvest(catalog_url)
  end

end
