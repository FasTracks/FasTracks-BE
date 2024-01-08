class SpotifyApiService
  def self.create_playlist(token, user_id, name)
    response = conn.post("users/#{user_id}/playlists") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
      req.headers["Content-Type"] = "application/json"
      req.body = {
        "name" => name,
        "public" => true,
        "description" => "Playlist created by FasTracks on Spotify API"
      }.to_json
    end

    response_conversion(response)
  end

  def self.add_tracks_to_playlist(token, id, track_uris)
    response = conn.post("playlists/#{id}/tracks") do |req|
    req.headers["Authorization"] = "Bearer #{token}"
    req.headers["Content-Type"] = "application/json"
    req.body = {uris: track_uris}.to_json
  end

    response_conversion(response)
  end

  def self.get_playlist(token, playlist_id)
    response = conn.get("playlists/#{playlist_id}") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
    end

    response_conversion(response)
  end

  def self.get_song_recommendations(token, seed_genres, target_tempo, limit)
    response = conn.get("recommendations?limit=#{limit}&seed_genres=#{seed_genres}&target_tempo=#{target_tempo}") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
    end

    response_conversion(response)
  end

  def self.get_user(token)
    response = conn.get("me") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
    end

    response_conversion(response)
  end

  def self.get_genres(token)
    response = conn.get("recommendations/available-genre-seeds") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
    end

    response_conversion(response)

  end

  def self.account_connection
    Faraday.new(url: "https://accounts.spotify.com/") do |conn|
      # conn.request :url_encoded
    end
  end

  def self.conn
    Faraday.new(url: "https://api.spotify.com/v1/") do |conn|
      conn.request :url_encoded
    end
  end

  def self.response_conversion(response)
    {status: response.status, data: JSON.parse(response.body, symbolize_names: true)}
  end
end
