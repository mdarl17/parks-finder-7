require 'rails_helper'

RSpec.describe "Park Search (w/ webmock gem)" do 
  describe "happy path" do 
    it "allows users to search parks by state" do
      json_response = File.read("spec/fixtures/tennessee_state_parks.json")
      all_states_json_response = File.read("spec/fixtures/us_state_parks.json")
      
      stub_request(:get, "https://developer.nps.gov/api/v1/parks?stateCode=TN").to_return(status: 200, body: json_response)
      
      res_from_stub = Net::HTTP.get_response(URI("https://developer.nps.gov/api/v1/parks?stateCode=TN"))

      res_body = res_from_stub.body
      ten_all = JSON.parse(res_body, symbolize_names: true)
      ten_data = ten_all[:data]
      park_results_count = ten_data.count
      all_states_data = JSON.parse(all_states_json_response, symbolize_names: true)[:data]
      
      visit root_path

      select "Tennessee", from: :state
      click_button "Find Parks"
      expect(current_path).to eq(parks_path)

      expect(page.status_code).to eq(200)
      expect(page).to have_content("Total returned: 15 parks")
      
      within("#search-hdr1-state-name") do
        expect(page).to have_content("Tennessee's Parks")
      end

      ten_data.each.with_index do |state, i|
        expect(find("#search-park-name-#{i}").text).to eq(state[:fullName])
      end

      ten_data.each.with_index do |state, i|
        expect(find("#search-description-#{i}").text).to eq(state[:description])
      end

      ten_data.each.with_index do |state, i|
        expect(find("#search-directions-#{i}").text).to eq(state[:directionsInfo])
      end
      
      all(".search-hours").each_with_index do |state, i|
        expect(find("#search-hours-#{i}").text).to eq(state[:standardHours])
      end
    end
  end 
end