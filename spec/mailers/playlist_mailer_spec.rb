require 'rails_helper'

RSpec.describe PlaylistMailer do
  it "sends an email with a playlist link" do
    user = File.read('spec/fixtures/user/user.json')
    parsed_user = JSON.parse(user, symbolize_names: true)
    songs = ["spotify:track:1234567890"]
    playlist = File.read('spec/fixtures/playlists/get_playlist.json')

    stub_request(:get, "https://api.spotify.com/v1/me").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Bearer 31nantjxmjfmry3ogfhzrffdwveu',
        'User-Agent'=>'Faraday v2.8.1'
          }).
        to_return(status: 200, body: user, headers: {})

    stub_request(:post, "https://api.spotify.com/v1/users/31nantjxmjfmry3ogfhzrffdwveu/playlists").
      with(
        body: "{\"name\":\"test playlist\",\"public\":true,\"description\":\"Playlist created by FasTracks on Spotify API\"}",
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Bearer 31nantjxmjfmry3ogfhzrffdwveu',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v2.8.1'
          }).
        to_return(status: 200, body: playlist, headers: {})

    stub_request(:post, "https://api.spotify.com/v1/playlists/3cEYpjA9oz9GiPac4AsH4n/tracks").
      with(
          body: "{\"uris\":[\"spotify:track:1234567890\"]}",
          headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Bearer 31nantjxmjfmry3ogfhzrffdwveu',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v2.8.1'
          }).
        to_return(status: 200, body: "snapshot id".to_json, headers: {})

    stub_request(:get, "https://api.spotify.com/v1/playlists/3cEYpjA9oz9GiPac4AsH4n").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Bearer 31nantjxmjfmry3ogfhzrffdwveu',
        'User-Agent'=>'Faraday v2.8.1'
          }).
        to_return(status: 200, body: playlist, headers: {})

    SpotifyFacade.generate_spotify_playlist(parsed_user[:id], ["spotify:track:1234567890"], "test playlist")
  end

  it "can send an email" do
    
  end
end