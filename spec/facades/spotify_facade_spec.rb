require "rails_helper"

RSpec.describe SpotifyFacade do
  before(:each) do
    @rec_response = File.read("spec/fixtures/songs_selection/songs.json")
    # GET song recommendations
    stub_request(:get, "https://api.spotify.com/v1/recommendations?limit=10&seed_genres=pop&target_tempo=140")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer 1234",
          "User-Agent" => "Faraday v2.8.1"
        }
      )
      .to_return(status: 200, body: @rec_response, headers: {})
    end

  describe "class methods" do
    describe "::get_song_recommendations" do
      it "Retrieve a selection of songs based on input and passes data to #add_tracks" do
        # Set the request content type to JSON
        response = SpotifyFacade.get_song_recommendations("1234", "pop", "140", 10)

        expect(response[:status]).to eq(200)
        expect(response[:data]).to be_an(Array)
        expect(response[:data].first).to include("spotify:track:")
      end
    end

    describe "::generate_spotify_playlist" do
      before(:each) do
        user_response = File.read("spec/fixtures/user/user.json")
        # Get user id
        stub_request(:get, "https://api.spotify.com/v1/me")
          .with(headers: {"Authorization" => "Bearer 1234"})
          .to_return(status: 200, body: {id: "12345"}.to_json, headers: {})
        # Create playlist
        stub_request(:post, "https://api.spotify.com/v1/users/12345/playlists")
          .with(
            headers: {"Authorization" => "Bearer 1234", "Content-Type" => "application/json"},
            body: "{\"name\":\"FT HIIT Pop\",\"public\":true,\"description\":\"Playlist created by FasTracks on Spotify API\"}"
          )
          .to_return(status: 201, body: {id: "testID"}.to_json, headers: {})
        # Add tracks to playlist
        stub_request(:post, "https://api.spotify.com/v1/playlists/testID/tracks")
          .with(
            headers: {"Authorization" => "Bearer 1234", "Content-Type" => "application/json"},
            body: "{\"uris\":[\"spotify:track:4iV5W9uYEdYUVa79Axb7Rh\"]}"
          )
          .to_return(status: 201, body: "".to_json, headers: {})
      end

      it "gets a user_id, creates a playlist, and adds tracks to it" do
        playlist = File.read("spec/fixtures/playlists/get_playlist.json")
        
        stub_request(:get, "https://api.spotify.com/v1/playlists/testID")
        .with(
          headers: {"Authorization" => "Bearer 1234"}
          )
        .to_return(status: 200, body: playlist, headers: {})

        results = SpotifyFacade.generate_spotify_playlist("1234", ["spotify:track:4iV5W9uYEdYUVa79Axb7Rh"], "FT HIIT Pop")

        expect(results[:status]).to eq(200)
        expect(results[:data]).to be_a(Hash)
        expect(results[:data]).to have_key(:id)
      end
    end
  end
end
