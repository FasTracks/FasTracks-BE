class SpotifyFacade
  # @return {Hash}: track uris in spotify playlist request format (spotify:track:1234567890)
  def self.get_song_recommendations(token, seed_genres, target_tempo, limit)
    response = SpotifyApiService.get_song_recommendations(token, seed_genres, target_tempo, limit)
    track_uris = []

    if response[:status] == 200
      track_uris = response[:data][:tracks].map { |track| "spotify:track:" + track[:id] }
    end

    {status: response[:status], data: track_uris}
  end

  def self.generate_spotify_playlist(token, track_uris, playlist_name)
    user_id = SpotifyApiService.get_user(token)[:data][:id]

    playlist_id = SpotifyApiService.create_playlist(token, user_id, playlist_name)[:data][:id]
    # this returns a snapshot id; unused
    SpotifyApiService.add_tracks_to_playlist(token, playlist_id, track_uris)
    # returns {status: ###, data: <playlist JSON>}
    return SpotifyApiService.get_playlist(token, playlist_id)
  end
end
