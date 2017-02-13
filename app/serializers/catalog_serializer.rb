class CatalogSerializer < ActiveModel::Serializer
  has_many :datasets, root: :dataset, serializer: Catalog::DatasetSerializer
  attributes :issued, :modified

  def attributes
    data ||= {}
    data[:title] = "Catálogo de datos abiertos de #{object.organization.title}"
    data[:description] = ''
    data[:homepage] = ''
    data[:language] = 'es'
    data[:license] = 'https://datos.gob.mx/libreusomx/'
    data.merge super
  end

  def issued
    object.created_at
  end

  def modified
    object.publish_date
  end

  def datasets
    object.datasets.select do |dataset|
      dataset.distributions.map(&:published?).any?
    end
  end
end
