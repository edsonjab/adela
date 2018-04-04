require 'spec_helper'

describe ShogunHarvestWorker do
  let(:catalog_url) { Faker::Internet.url }
  let(:worker) { ShogunHarvestWorker.new }

  it 'enqueues the harvest job' do
    ShogunHarvestWorker.perform_async(catalog_url)
    expect(ShogunHarvestWorker).to have_enqueued_job(catalog_url)
  end

  it 'sends a post to shogun service' do
    response = worker.perform(catalog_url)
    expect(response.request.http_method).to eq(Net::HTTP::Post)
  end

  it 'sends the catalog_url to the harvest endpoint' do
    response = worker.perform(catalog_url)
    response_url = URI.unescape(response.request.uri.to_s)
    expect(response_url).to eq("http://#{SHOGUN_BASE_URI}/v1/harvest?url=#{catalog_url}")
  end

  it 'should update organization name wiht updateorg endpoint' do
    name = "presidencia_new"
    new_name = "presidencia"
    response = worker.updateorg(name, new_name)
    expect( response.body ).to eq("{\"Organization Updated\": \"#{new_name}\"}")
  end
end
