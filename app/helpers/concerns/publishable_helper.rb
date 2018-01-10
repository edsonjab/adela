module Concerns
  module PublishableHelper
    def state_description(resource)
      case resource.state
      when 'published'
        'Publicado'
      when 'documented', 'refined'
        documented_or_refined_state(resource)
      else
        'Falta información'
      end
    end

    def documented_or_refined_state(resource)
      case resource
      when Dataset
        dataset_state_description(resource)
      when Distribution
        'Listo para publicar'
      end
    end

    def dataset_state_description(dataset)
      if dataset.distributions.where.not(state: %w(broke refining)).any?
        'Listo para publicar'
      else
        'Falta información'
      end
    end
  end
end
