class ParksController < ApplicationController
##### TODO: RAISE NOT_FOUND ERROR
  def index
    @state = ParksFacade.new(params[:state]).state_code_to_name

    conn = Faraday.new(url: "https://developer.nps.gov") do |faraday|
      faraday.headers["X-Api-Key"] = Rails.application.credentials.nps_api[:key]
    end
    response = conn.get("/api/v1/parks?stateCode=#{params[:state]}")
    park_data = JSON.parse(response.body, symbolize_names: true)
    @state_code = park_data[:data][0][:states].split(" ")[0]
    @total = park_data[:total]
    @parks = park_data[:data].map do |park|
      {
        name: park[:fullName],
        description: park[:description],
        directions: park[:directionsInfo],
        hours: park[:operatingHours][0][:standardHours]
      }
    end
  end
end