require "rails_helper"

describe SpotifyApiService do
  context "class methods" do
    context "#create_playlist" do
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
  end
end