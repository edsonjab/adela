require 'rubygems'
require 'vcr'

class VCRTest < Test::Unit::TestCase
  def test_dashboard_call_ajax
    VCR.use_cassette("synopsis") do
      response = Net::HTTP.get_response(URI('http://localhost:3000/instituciones/mexico-abierto'))
       assert_match /localhost/, response.body
    end
  end
end
