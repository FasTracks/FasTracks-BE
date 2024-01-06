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
      #Determind number of songs and tempo based on type of workout 
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
      #Determine error status
      if response.status == 401
        render json: { error: { message: "Invalid access token", status: 401 } }
      elsif response.status == 404
        render json: { error: { message: "Not Found", status: 404 } }
      elsif response.status != 200
        render json: { error: { message: "Unexpected error", status: response.status } }
      else
        json = JSON.parse(response.body, symbolize_names: true)
  
        track_and_artist_hash = {}
        playlist_duration_ms = 0
        #Iterate through the json response to get the duration in milliseconds, the track name and artist names.
        json[:tracks].each do |track|
          playlist_duration_ms += track[:duration_ms]
          track_name = track[:name]
          artist_names = track[:artists].map { |artist| artist[:name] }
          track_and_artist_hash[track_name] = artist_names
        end
        #Convert the milliseconds to minutes and seconds
        playlist_duration_seconds = playlist_duration_ms / 1000
        playlist_duration_minutes = playlist_duration_seconds / 60
        playlist_duration_remainder_seconds = (playlist_duration_seconds % 60).round(2)
        converted_duration = {duration:"#{playlist_duration_minutes}:#{playlist_duration_remainder_seconds}"}
        #Merge the track name and artist name with the converted duration so it is in one variable
        playlist_data_hash = track_and_artist_hash.merge(converted_duration)
      end
    end 
    #JSON data with track and artist name as well as total duration
    x = JSON.generate(playlist_data_hash)
  end
end