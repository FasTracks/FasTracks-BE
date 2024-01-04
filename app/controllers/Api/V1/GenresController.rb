class Api::V1::GenresController < ApplicationController
  def index
    if params[:bearer] == ""
      render json: {error: {message: "No token provided", status: 401}}
    elsif bearer = params[:bearer]

      conn = Faraday.new(url: "https://api.spotify.com/") do |faraday|
        faraday.headers['Authorization'] = "Bearer #{bearer}"
        faraday.adapter Faraday.default_adapter 
      end

      response = conn.get("v1/recommendations/available-genre-seeds")

      json = JSON.parse(response.body, symbolize_names: true)
      @genres = json[:genres]
    end
  end
end
