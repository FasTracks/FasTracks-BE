class SpotifyFacade
  # @return {Hash}: track uris in spotify playlist request format (spotify:track:1234567890)
  def self.get_song_recommendations(token, seed_genres, target_tempo, limit)
    response = SpotifyApiService.get_song_recommendations(token, seed_genres, target_tempo, limit)
    track_uris = []

    if response[:status] == 200
      track_uris = convert_track_uris(response[:data][:tracks])
    end

    {status: response[:status], data: track_uris}
  end

  def self.generate_spotify_playlist(token, track_uris, playlist_name)
    user_info = SpotifyApiService.get_user(token)
    user_id = user_info[:data][:id]

    playlist_id = SpotifyApiService.create_playlist(token, user_id, playlist_name)[:data][:id]
    # this returns a snapshot id; unused
    SpotifyApiService.add_tracks_to_playlist(token, playlist_id, track_uris)
    # returns {status: ###, data: <playlist JSON>}

    playlist_info = SpotifyApiService.get_playlist(token, playlist_id)
    require 'pry'; binding.pry
    #send playlist email to user
    PlaylistSenderJob.perform_async(user_info[:data][:email], playlist_info[:data][:external_urls][:spotify])

    return playlist_info
  end

  def self.convert_track_uris(tracks)
    tracks.map { |track| track[:uri] }
  end
end
