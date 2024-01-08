require "rails_helper"

describe SpotifyApiService do
  context "class methods" do
    context "#create_playlist" do
      it "creates a new playlist" do
        new_playlist = File.read("spec/fixtures/playlists/create_playlist.json")
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

    context "#add_tracks_to_playlist" do
      it "can add tracks to an existing playlist" do
        response_stub = File.read("spec/fixtures/playlists/add_tracks_to_playlist.json")
        stub_request(:post, "https://api.spotify.com/v1/playlists/1234/tracks").
         with(
           body: "{\"uris\":\"spotify:track:4QeoDcR16IHpmmgFGQDrCp\"}",
           headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>'Bearer 1234',
              'Content-Type'=>'application/json',
              'User-Agent'=>'Faraday v2.8.1'
           }
          )
        .to_return(status: 200, body: response_stub, headers: {})
        playlist = SpotifyApiService.add_tracks_to_playlist("1234", "1234", "spotify:track:4QeoDcR16IHpmmgFGQDrCp")
        expect(playlist).to be_a(Hash)
        expect(playlist).to have_key(:data)
        expect(playlist[:data]).to be_a(Hash)
        expect(playlist[:data]).to have_key(:snapshot_id)
      end
    end

    context "#get_song_recommendations" do
      it "can get song recommendations" do

      end
    end

    context "#get_user" do
     it "retrieves a user ID" do

     end
    end

    context "#get_genres" do
      it "retrieves a list of genres" do

      end
    end
  end
end