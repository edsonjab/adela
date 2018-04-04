class ShogunService
  include HTTParty
  base_uri SHOGUN_BASE_URI

  def self.harvest(catalog_url)
    options = { query: { url: catalog_url } }
    post('/v1/harvest', options)
  end

  def self.updateorg(oldname, newname)
    options = { query: { newname: newname, oldname: oldname } }
    post('/v1/updateorg', options)
  end

end
