class Api::V1::SongsController < ApplicationController
  def index
    #Check that bearer token is present
    if params[:bearer] == ""
      render json: {error: {message: "No token provided", status: 401}}
    else bearer = params[:bearer]
    #Establish Faraday connection
      conn = Faraday.new(url: "https://api.spotify.com/") do |faraday|
        faraday.headers['Authorization'] = "Bearer #{bearer}"
        faraday.adapter Faraday.default_adapter 
      end
      if params[:workout] == "HIIT" || "Strength"
          num_songs = 10
          tempo = 140
        elsif 
          params[:workout] == "Restore" || "Yoga"
          num_songs = 10
          tempo = 80
        elsif 
          params[:workout] == "Endurance"
          num_songs = 20
          tempo = 120
        else render json: {error: {message: "Invalid Workout Provided", status: 422}}
      end
      #Make endpoint connection
      response = conn.get("v1/recommendations?limit=#{num_songs}&seed_genres=#{params[:genre]}&target_tempo=#{tempo}")
      # json = JSON.parse(response.body, symbolize_names: true)

      if response.status == 401
        render json: { error: { message: "Invalid access token", status: 401 } }
      elsif response.status == 404
        render json: { error: { message: "Not Found", status: 404 } }
      elsif response.status != 200
        render json: { error: { message: "Unexpected error", status: response.status } }
      else
        json = JSON.parse(response.body, symbolize_names: true)
      end
      
      # json[:tracks].each do |track|
      #   track[:artists].each do |artist|
      #     artist[:name]
      #   end
      #   track[:name]
      # end
      # require 'pry'; binding.pry
    end 
  end
end