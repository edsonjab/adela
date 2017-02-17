FactoryGirl.define do
  factory :organization do
    title { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    landing_page { Faker::Internet.url }
    gov_type { ['federal', 'state', 'municipal', 'autonomous'].sample }

    factory :federal_organization do
      gov_type { 'federal' }
    end

    factory :statal_organization do
      gov_type { 'state' }
    end

    factory :municipal_organization do
      gov_type { 'municipal' }
    end

    factory :autonomous_organization do
      gov_type { 'autonomous' }
    end

    factory :organization_with_sector do
      after(:create) do |organization|
        create(:organization_sector, organization: organization)
      end
    end
  end
end
