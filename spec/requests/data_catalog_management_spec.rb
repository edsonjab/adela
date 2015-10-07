require 'spec_helper'

feature "data catalog management" do

  background do
    @organization = FactoryGirl.create(:organization)
    @empty_response = {}
  end

  scenario "can consume published catalog data" do
    pending("catalogs are getting finished") do
      given_there_is_a_catalog_published 10.days.ago
      get "/#{@organization.slug}/catalogo.json"
      gets_catalog_json_data_in response
    end
  end

  scenario "can't consume unpublished catalog data" do
    pending("catalogs are getting finished") do
      given_there_is_an_inventary_by("CONEVAL", "unpublished")
      get "/coneval/catalogo.json"
      gets_empty response
    end
  end

  scenario "can see all the catalogs available through the api" do
    pending("catalogs are getting finished") do
      given_there_is_an_inventary_by("CONEVAL", "published")
      given_there_is_an_inventary_by("Presidencia", "published")
      given_there_is_an_inventary_by("Hacienda", "unpublished")
      get "/api/v1/organizations/catalogs.json"
      gets_all_catalogs_urls_in response
    end
  end

  scenario "can consume catalog data even with catalog empty fields" do
    pending("catalogs are getting finished") do
      catalog_file = File.new("#{Rails.root}/spec/fixtures/files/catalog_with_blanks.csv")
      catalog =  FactoryGirl.create(:published_catalog, :publish_date => 1.day.ago, :csv_file => catalog_file)
      catalog.update_attributes(:organization_id => @organization.id)

      get "/#{@organization.slug}/catalogo.json"

      json_response = JSON.parse(response.body)
      json_response["dataset"].size == 2
      json_response["dataset"][0]["keywords"].should be_nil
    end
  end

  scenario "catalog will have correct DCAT key names" do
    pending("catalogs are getting finished") do
      catalog_file = File.new("#{Rails.root}/spec/fixtures/files/conflicting_catalog_issue-106.csv")
      catalog =  FactoryGirl.create(:published_catalog, :publish_date => 1.day.ago, :csv_file => catalog_file)
      catalog.update_attributes(:organization_id => @organization.id)

      dcat_keys = %w{ title description homepage issued modified language license dataset }
      dcat_dataset_keys = %w{ title description modified contactPoint identifier accessLevel accessLevelComment spatial language publisher keyword distribution }
      dcat_distribution_keys = %w{ title description license downloadURL mediaType format byteSize temporal spatial }

      get "/#{@organization.slug}/catalogo.json"
      json_response = JSON.parse(response.body)
      json_response.keys.should eq(dcat_keys)
      json_response["dataset"].last.keys.should eq(dcat_dataset_keys)
      json_response["dataset"].last["distribution"].last.keys.should eq(dcat_distribution_keys)

      # Makes damn sure that no foreign attributes are set in the model
      # See: https://github.com/mxabierto/adela/issues/106
      dataset = ActiveSupport::JSON.decode(catalog.datasets.last.to_json)
      dataset.keys.include?("erick.maldonado@indesol.gob.mx").should eq(false)
    end
  end

  def given_there_is_a_catalog_published(days_ago)
    @catalog = FactoryGirl.create(:published_catalog, :publish_date => days_ago)
    @catalog.update_attributes(:organization_id => @organization.id)
  end

  def gets_catalog_json_data_in(response)
    json_response = JSON.parse(response.body)
    json_response["title"].should == "Catálogo de datos abiertos de #{@organization.title}"
    json_response["dataset"][0]["distribution"].size == 3
    json_response["dataset"][1]["distribution"].size == 4
    json_response["dataset"][1]["identifier"] == "indice-rezago-social"
  end

  def gets_empty(response)
    json_response = JSON.parse(response.body)
    json_response.should == @empty_response
  end

  def given_there_is_an_inventary_by(organization_title, status)
    organization = FactoryGirl.create(:organization, :title => organization_title)
    case status
    when "published"
      catalog = FactoryGirl.create(:published_catalog)
    when "unpublished"
      catalog = FactoryGirl.create(:catalog)
    end
    catalog.update_attributes(:organization_id => organization.id)
  end

  def gets_all_catalogs_urls_in(response)
    json_response = JSON.parse(response.body)
    json_response.size.should == 2
  end
end
