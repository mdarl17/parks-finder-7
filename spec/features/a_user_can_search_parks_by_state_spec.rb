require 'rails_helper'

# RSpec.describe "State Park Search", type: :feature do
#   scenario "User searches parks by state" do 
#     visit root_path

#     select "Tennessee", from: :state

#     click_on "Find Parks"

#     expect(current_path).to eq(parks_path)
#     expect(page).to have_content("total returned: 15 parks")
    
    
    # expect(page.all(".search-parks")[0]).to have_content("Andrew Johnson National Historic Site")
    # expect(page.all(".search-parks")[0]).to have_content("Andrew Johnson National Historic Site")
  # end

  describe "Park Search (w/ webmock gem)" do 
    describe "happy path" do 
      it "allows users to search parks by state" do
        json_response = File.read("spec/fixtures/tennessee_state_parks.json")
        stub_request(:get, "https://developer.nps.gov/api/v1/parks?stateCode=TN").to_return(status: 200, body: json_response)

        visit root_path

        select "Tennessee", from: :state
        click_button "Find Parks"

        expect(page.status_code).to eq(200)
        expect(page).to have_content("total returned: 15 parks")
        
        within("#search-hdr1-state-name") do
          expect(page).to have_content("Tennessee's Parks")
        end

        within("#search-park-name") do
          expect(page).to have_content("Andrew Johnson National Historic Site")
        end


        # expect(page).to have_content("Tennessee")

        # expect(page).to have_content("Andrew Johnson National Historic Site")

        # expect(page).to have_content("Andrew Johnson's complex presidency (1865-69)illustrates the Constitution at work following the Civil War. As the President and Congress disagreed on Reconstruction methods, the Constitution served as their guide on balance of powers, vetoes, and impeachment. In the end, it evolved as a living document with pivotal amendments on freedom, citizenship, and voting rights - topics still vital today.")
        # expect(page).to have_content("TN")

        # expect(page).to have_content("GPS The GPS setting for Andrew Johnson NHS may be listed as 121 Monument Ave, which is the park HQ in the National Cemetery. To arrive at the Visitor Center, use 101 North College Street, Greeneville, TN. Plane The closest airport is the Tri-Cities Regional Airport, 43 miles NE of Greeneville.From the airport, take I-81 South to exit 36 and follow the signs to Greeneville. Car From I-81S take exit 36 to Rt. 172 south to Greeneville.")
      end
    end 
  end
# end 