class SpotifyApiService
  def self.get_song_recommendations(token, seed_genres, target_tempo, limit)
    response = conn.get("recommendations?limit=#{limit}&seed_genres=#{seed_genres}&target_tempo=#{target_tempo}") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
    end

    response_conversion(response)
  end

  def self.get_user(token)
    begin
      response = conn.get("me") do |req|
        req.headers["Authorization"] = "Bearer #{token}"
      end

      response_conversion(response)
    end
  rescue Faraday::Error => e
    # You can handle errors here (4xx/5xx responses, timeouts, etc.)
    puts e.response[:status]
    puts e.response[:body]
  end

  def self.get_genres(token)
    begin
      response = conn.get("recommendations/available-genre-seeds") do |req|
        req.headers["Authorization"] = "Bearer #{token}"
      end

      response_conversion(response)
    end
  rescue Faraday::Error => e
    # You can handle errors here (4xx/5xx responses, timeouts, etc.)
    puts e.response[:status]
    puts e.response[:body]
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
