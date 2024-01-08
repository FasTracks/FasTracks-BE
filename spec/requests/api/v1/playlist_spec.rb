require "rails_helper"

describe Api::V1::PlaylistsController, type: :controller do
  before(:each) do
    @rec_response = File.read("spec/fixtures/songs_selection/songs.json")

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

    user_response = File.read("spec/fixtures/user/user.json")

    stub_request(:get, "https://api.spotify.com/v1/me")
      .with(headers: {"Authorization" => "Bearer 1234"})
      .to_return(status: 200, body: {id: "1234"}.to_json, headers: {})

    stub_request(:post, "https://api.spotify.com/v1/users/1234/playlists")
      .with(
        headers: {"Authorization" => "Bearer 1234", "Content-Type" => "application/json"},
        body: "{\"name\":\"FasTracks HIIT pop\",\"public\":true,\"description\":\"Playlist created by FasTracks on Spotify API\"}"
      )
      .to_return(status: 201, body: {id: "testID"}.to_json, headers: {})

    stub_request(:post, "https://api.spotify.com/v1/playlists/testID/tracks")
      .with(
        headers: {"Authorization" => "Bearer 1234", "Content-Type" => "application/json"},
        body: {uris: SpotifyFacade.convert_track_uris(JSON.parse(@rec_response, symbolize_names: true)[:tracks])}.to_json
      )
      .to_return(status: 201, body: "".to_json, headers: {})
    # stubbing GET playlists
    playlist = File.read("spec/fixtures/playlists/get_playlist.json")
      
    stub_request(:get, "https://api.spotify.com/v1/playlists/testID")
      .with(
        headers: {"Authorization" => "Bearer 1234"}
        )
      .to_return(status: 200, body: playlist, headers: {})
  end

  describe "#generate" do
    it "hands off playlist generation to the facade" do
      # As a FE App,
      # When I request to create a playlist,
      # I need BE service to create a playlist with POST to users/{user_id}/playlists
      # BE needs to fetch user_id with token at GET /me
      # then needs to create a playlist
      # Then BE needs to fill playlist with track URIs
      # Set the request content type to JSON
      request.headers["Content-Type"] = "application/json"
      workout = "HIIT"
      post :generate, params: {token: "1234", workout: workout, genre: "pop", playlist_name: "FT #{workout} Pop"}

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response).to have_key(:data)
      expect(parsed_response).to have_key(:status)
      expect(parsed_response[:data]).to have_key(:id)
      expect(parsed_response[:data]).to have_key(:href)
    end

    it "handles restore and yoga workouts" do
      stub_request(:post, "https://api.spotify.com/v1/users/1234/playlists")
      .with(
        headers: {"Authorization" => "Bearer 1234", "Content-Type" => "application/json"},
        body: "{\"name\":\"FasTracks Yoga pop\",\"public\":true,\"description\":\"Playlist created by FasTracks on Spotify API\"}"
      )
      .to_return(status: 201, body: {id: "testID"}.to_json, headers: {})

      workout = "Yoga"
      post :generate, params: {token: "1234", workout: workout, genre: "pop", playlist_name: "FT #{workout} Pop"}

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response).to have_key(:data)
      expect(parsed_response).to have_key(:status)
      expect(parsed_response[:data]).to have_key(:id)
      expect(parsed_response[:data]).to have_key(:href)
    end

    it "handles endurance workouts" do
      stub_request(:post, "https://api.spotify.com/v1/users/1234/playlists")
      .with(
        headers: {"Authorization" => "Bearer 1234", "Content-Type" => "application/json"},
        body: "{\"name\":\"FasTracks Endurance pop\",\"public\":true,\"description\":\"Playlist created by FasTracks on Spotify API\"}"
      )
      .to_return(status: 201, body: {id: "testID"}.to_json, headers: {})

      workout = "Endurance"
      post :generate, params: {token: "1234", workout: workout, genre: "pop", playlist_name: "FT #{workout} Pop"}

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response).to have_key(:data)
      expect(parsed_response).to have_key(:status)
      expect(parsed_response[:data]).to have_key(:id)
      expect(parsed_response[:data]).to have_key(:href)
    end

    context "sad tokens" do
      it "errors without a token" do
        json_response = File.read("spec/fixtures/songs_selection/songs_no_token.json")

        stub_request(:get, "https://api.spotify.com/v1/recommendations?limit=10&seed_genres=pop&target_tempo=140")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Authorization" => "Bearer",
              "User-Agent" => "Faraday v2.8.1"
            }
          )
          .to_return(status: 401, body: json_response, headers: {})

        post :generate, params: {token: nil, workout: "HIIT", genre: "pop"}

        expect(response).to be_successful

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response[:error][:message]).to eq("No token provided")
        expect(parsed_response[:error][:status]).to eq(401)
      end

      it "errors with a bad token" do
        json_response = File.read("spec/fixtures/songs_selection/songs_bad_token.json")

        stub_request(:get, "https://api.spotify.com/v1/recommendations?limit=10&seed_genres=pop&target_tempo=140")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Authorization" => "Bearer 1235",
              "User-Agent" => "Faraday v2.8.1"
            }
          )
          .to_return(status: 401, body: json_response, headers: {})

        post :generate, params: {token: 1235, workout: "HIIT", genre: "pop"}

        expect(response).to be_successful

        parsed_response = JSON.parse(json_response, symbolize_names: true)
        expect(parsed_response[:error][:message]).to eq("Invalid access token")
        expect(parsed_response[:error][:status]).to eq(401)
      end
    end
  end
end
