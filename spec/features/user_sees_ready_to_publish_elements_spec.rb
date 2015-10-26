require 'spec_helper'

feature User, 'sees ready to publish elements:' do
  before do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'and can select them for publishing', js: true do
    dataset = create :dataset, :distributions, :sector, title: "My dataset", description: "My custom description"
    given_organization_has_catalog_with [dataset]

    click_link "Catálogo de Datos"
    expect(page).to have_content "My dataset"
    expect(page).to have_content "Listo para publicar"

    dataset_distributions.each do |distribution_row|
      within distribution_row do
        expect(ready_to_publish_checkbox).to be_checked
        expect(ready_to_publish_row_color(distribution_row)).to eq "green"
      end
    end

    click_button "Publicar"
    expect(page).to have_content "My dataset"

    dataset.distributions.each do |resource|
      expect(page).to have_content resource.title
      expect(page).to have_content resource.download_url.truncate(30)
    end

    expect(page).to have_content I18n.t('agreement.publish')
    expect(page).to have_content "Confirmo que la información está validada por la institución"
    expect(page).to have_button "Publicar"
  end

  def dataset_distributions
    all("tr.distribution")
  end

  def ready_to_publish_checkbox
    find("input[type='checkbox']")
  end

  def ready_to_publish_row_color(row)
    if row[:class].include? "success"
      "green"
    end
  end

  def given_organization_has_catalog_with(datasets)
    create :inventory, :elements, organization: @user.organization
    create :opening_plan, organization: @user.organization
    create :catalog, datasets: datasets, organization: @user.organization
    @user.organization.reload
  end
end
