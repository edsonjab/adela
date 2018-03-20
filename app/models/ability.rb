class Ability
  include CanCan::Ability

  def initialize(user)
    if user&.has_role? :admin
      can :manage, User
      can :manage, Organization
    end
    can :manage, Catalog if user&.organization

    can :manage, Dataset do |dataset|
      dataset.organization == user&.organization
    end

    can :manage, Distribution do |distribution|
      distribution.organization == user&.organization
    end
  end
end
