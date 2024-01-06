class Api::V1::PlaylistsController < ApplicationController
  def songs
    # Check that bearer token is present
    if params[:token] == ""
      render json: {error: {message: "No token provided", status: 401}}
    else
      token = params[:token]
      # Determine number of songs and tempo based on type of workout
      if params[:workout] == "HIIT" || params[:workout] == "Strength"
        num_songs = 10
        tempo = 140
      elsif params[:workout] == "Restore" || params[:workout] == "Yoga"
        num_songs = 10
        tempo = 80
      elsif params[:workout] == "Endurance"
        num_songs = 20
        tempo = 120
      else
        render json: {error: {message: "Invalid Workout Provided", status: 422}}
      end

      # Making Faraday connection
      response = SpotifyApiService.get_song_recommendations(
        token, params[:genre], tempo, num_songs
      )
      # Determine error status
      if response[:status] == 401
        render json: {error: {message: "Invalid access token", status: 401}}
      elsif response[:status] == 404
        render json: {error: {message: "Not Found", status: 404}}
      elsif response[:status] != 200
        render json: {error: {message: "Unexpected error", status: response[:status]}}
      else
        # Send songs recs over to #add_tracks controller action
        add_tracks(response[:data])
      end
    end
  end

  private

  def add_tracks(track_data)
    # Need to create create a playlist
    # playlist_response = SpotifyApiService.create_playlist(token: token, name: params[:name], description: params[:description], public: true)

    # this is the POST body
    # {
    #     "uris": [
    #         "string"
    #     ],
    #     "position": 0
    # }
    # add tracks to playlist

    # def serve_new_playlist_with_tracks(playlist_id)
    # Service call to get playlist
    # somehow serve playlist url back to FE
    # end
  end
end
