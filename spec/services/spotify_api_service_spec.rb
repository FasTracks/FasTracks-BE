require "rails_helper"

describe SpotifyApiService do
  describe "class methods" do
    describe "::create_playlist" do
      it "creates a new playlist" do
        new_playlist = File.read("spec/fixtures/playlists/new_playlist.json")
        stub_request(:post, "https://api.spotify.com/v1/users/1234/playlists").
          with(
            body: "{\"name\":\"test\",\"public\":true,\"description\":\"Playlist created by FasTracks on Spotify API\"}",
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>'Bearer 1234',
              'Content-Type'=>'application/json',
              'User-Agent'=>'Faraday v2.8.1'
            }
          )
          .to_return(status: 200, body: new_playlist, headers: {})

        playlist = SpotifyApiService.create_playlist("1234", "1234", "test")
        expect(playlist).to be_a(Hash)
        expect(playlist).to have_key(:data)
        expect(playlist[:data]).to be_a(Hash)
        expect(playlist[:data]).to have_key(:id)
        expect(playlist[:data][:id]).to be_a(String)
      end
    end

    describe "::get_song_recommendations" do
      it "gets song recommendations" do
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

        songs = SpotifyApiService.get_song_recommendations("1234", "pop", 140, 10)
        expect(songs).to be_a(Hash)
        expect(songs).to have_key(:data)
        expect(songs[:data]).to have_key(:tracks)
      end
    end

    describe "::add_tracks_to_playlist" do
      it "adds tracks to a playlist" do
        @rec_response = File.read("spec/fixtures/songs_selection/songs.json")
        track_uris = SpotifyFacade.convert_track_uris(JSON.parse(@rec_response, symbolize_names: true)[:tracks])

        stub_request(:post, "https://api.spotify.com/v1/playlists/testID/tracks")
          .with(
            headers: {"Authorization" => "Bearer 1234", "Content-Type" => "application/json"},
            body: {uris: track_uris}.to_json
          )
          .to_return(status: 201, body: "".to_json, headers: {})

        playlist = SpotifyApiService.add_tracks_to_playlist("1234", "testID", track_uris)
        expect(playlist).to be_a(Hash)
        expect(playlist).to have_key(:status)
        expect(playlist[:status]).to eq 201
      end
    end

    describe "::get_playlist" do
      it "returns a playlist" do
        playlist = File.read("spec/fixtures/playlists/get_playlist.json")
        stub_request(:get, "https://api.spotify.com/v1/playlists/testID").
          with({headers: {"Authorization" => "Bearer 1234"}}).
          to_return(status: 200, body: playlist, headers: {})

        playlist = SpotifyApiService.get_playlist("1234", "testID")
        expect(playlist).to be_a(Hash)
        expect(playlist).to have_key(:data)
        expect(playlist[:data]).to be_a(Hash)
        expect(playlist[:data]).to have_key(:id)
      end
    end

    describe "::get_user" do
      it "returns a user" do
        user = File.read("spec/fixtures/user/user.json")
        stub_request(:get, "https://api.spotify.com/v1/me").
          with({headers: {"Authorization" => "Bearer 1234"}}).
          to_return(status: 200, body: user, headers: {})

        user = SpotifyApiService.get_user("1234")
        expect(user).to be_a(Hash)
        expect(user).to have_key(:data)
        expect(user[:data]).to have_key(:id)
      end
    end

    describe "::get_genres" do
      it "returns a list of genres" do
        genres = File.read("spec/fixtures/genres/genres.json")
        stub_request(:get, "https://api.spotify.com/v1/recommendations/available-genre-seeds").
          with({headers: {"Authorization" => "Bearer 1234"}}).
          to_return(status: 200, body: genres, headers: {})

        genres = SpotifyApiService.get_genres("1234")
        expect(genres).to be_a(Hash)
        expect(genres).to have_key(:data)
        expect(genres[:data][:genres]).to be_a(Array)
      end
    end

    describe "::account_connection" do
      it "returns a Spotify account connection" do
        request = SpotifyApiService.account_connection

        expect(request).to be_a(Faraday::Connection)
        expect(request.url_prefix.host).to eq "accounts.spotify.com"
      end
    end

    describe "::response_conversion" do
      it "converts a response to a hash" do
        response = Faraday::Response.new(status: 200, body: "".to_json)
        hash = SpotifyApiService.response_conversion(response)
        expect(hash).to be_a(Hash)
        expect(hash).to have_key(:data)
        expect(hash).to have_key(:status)
      end
    end
  end
end