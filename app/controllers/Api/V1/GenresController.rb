class Api::V1::GenresController < ApplicationController
  def index
    if params[:token] == ""
      render json: {error: {message: "No token provided", status: 401}}
    elsif bearer = params[:token]

      conn = Faraday.new(url: "https://api.spotify.com/") do |faraday|
        faraday.headers['Authorization'] = "Bearer #{token}"
        faraday.adapter Faraday.default_adapter 
      end

      response = conn.get("v1/recommendations/available-genre-seeds")

      json = JSON.parse(response.body, symbolize_names: true)
    end
  end
end
