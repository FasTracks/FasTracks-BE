class Api::V1::PlaylistsController < ApplicationController
  def songs
    token = params[:token]
    # set defual songs & tempo
    num_songs = 10
    tempo = 140

    # Check that bearer token is present
    return render json: { error: { message: 'No token provided', status: 401 } } if token == '' || token.nil?

    case params[:workout]
    when 'HIIT', 'Strength'
      num_songs = 10
      tempo = 140
    when 'Restore', 'Yoga'
      num_songs = 10
      tempo = 80
    when 'Endurance'
      num_songs = 20
      tempo = 120
    else
      return render json: { error: { message: 'Invalid Workout Provided', status: 422 } }
    end

    # Making Faraday connection
    response = SpotifyApiService.get_song_recommendations(
      token, params[:genre], tempo, num_songs
    )

    if response[:status] == 200
      # Send songs recs over to #add_tracks controller action
      add_tracks(response[:data])
    else
      case response[:status]
      when 401
        render json: { error: { message: 'Invalid access token', status: 401 } }
      when 404
        render json: { error: { message: 'Not Found', status: 404 } }
      else
        render json: { error: { message: 'Unexpected error', status: response[:status] } }
      end
    end
  end

  private

  def add_tracks(track_data)
    token = params[:token]

    user_id = SpotifyApiService.get_user(token)[:data][:id]
    # Need to create create a playlist
    playlist_response = SpotifyApiService.create_playlist(token, user_id, params[:playlist_name])
    # convert track data to contiguous string
    track_uris = track_data[:tracks].map { |track| 'spotify:track:' + track[:id] }
    # this returns a snapshot id
    # perhaps we sad path (gracefully handle) for bad track_uris -- low criticality
    SpotifyApiService.add_tracks_to_playlist(token, playlist_response[:data][:id], track_uris)

    # need to add tracks to playlist
    # this is the POST body
    # {
    #     "uris": [
    #         "string"
    #     ],
    #     "position": 0
    # }
    # add tracks to playlist

    # def serve_new_playlist_with_tracks(playlist_id)
    # somehow serve playlist url back to FE
    # end
  end
end
