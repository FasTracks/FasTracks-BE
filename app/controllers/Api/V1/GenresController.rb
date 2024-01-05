class Api::V1::GenresController < ApplicationController
  def index
    if params[:bearer] == ""
      render json: {error: {message: "No token provided", status: 401}}
    else bearer = params[:bearer]

      conn = Faraday.new(url: "https://api.spotify.com/") do |faraday|
        faraday.headers['Authorization'] = "Bearer #{bearer}"
        faraday.adapter Faraday.default_adapter 
      end

      response = conn.get("v1/recommendations/available-genre-seeds")

      if response.status == 401
        render json: { error: { message: "Invalid access token", status: 401 } }
      elsif response.status == 404
        render json: { error: { message: "Not Found", status: 404 } }
      elsif response.status != 200
        render json: { error: { message: "Unexpected error", status: response.status } }
      else
        json = JSON.parse(response.body, symbolize_names: true)
        @genres = json[:genres]
      end
      # response = conn.get("v1/recommendations/available-genre-seeds")

      # if response.body == ""
      #   render json: {error: {message: "No token provided", status: 401}}
      # end
      # require 'pry'; binding.pry

      # json = JSON.parse(response.body, symbolize_names: true)
      # @genres = json[:genres]


    end
  end
end
