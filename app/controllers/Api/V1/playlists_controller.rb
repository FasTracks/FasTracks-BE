class Api::V1::PlaylistsController < ApplicationController
  def generate
    token = params[:token]
    # set defual songs & tempo
    num_songs = 10
    tempo = 140

    # Check that bearer token is present
    if token == "" || token.nil?
      return render json: {error: {message: "No token provided", status: 401}}
    else
      case params[:workout]
      when "HIIT", "Strength"
        num_songs = 10
        tempo = 140
      when "Restore", "Yoga"
        num_songs = 10
        tempo = 80
      when "Endurance"
        num_songs = 20
        tempo = 120
      else
        return render json: {error: {message: "Invalid Workout Provided", status: 422}}
      end
    end

    # Making Faraday connection
    tracks_response = SpotifyFacade.get_song_recommendations(token, params[:genre], tempo, num_songs)

    if tracks_response[:status] == 200
      # Send songs recs over to #add_tracks controller action
      playlist_response = SpotifyFacade.generate_spotify_playlist(token, tracks_response[:data])

      render json: playlist_response
    else
      case tracks_response[:status]
      when 401
        render json: {error: {message: "Invalid access token", status: 401}}
      when 404
        render json: {error: {message: "Not Found", status: 404}}
      else
        render json: {error: {message: "Unexpected error", status: tracks_response[:status]}}
      end
    end
  end
end
