class Api::V1::GenresController < ApplicationController
  def index
    bearer = params[:bearer]

    conn = Faraday.new(url: "https://api.spotify.com/") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{bearer}"
    end

    response = conn.get("v1/recommendations/available-genre-seeds")

    json = JSON.parse(response.body, symbolize_names: true)
    @genres = json[:results]
    require 'pry'; binding.pry
  end
end
