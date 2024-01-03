class Api::V1::GenresController < ApplicationController
  def index
    conn = Faraday.new(url: "https://api.spotify.com/") do |faraday|
      faraday.headers["Bearer"] = Rails.application.credentials.spotify[:token]
    end

    response = conn.get("v1/recommendations/available-genre-seeds")

    json = JSON.parse(response.body, symbolize_names: true)
    @members = json[:results]
  end
end
