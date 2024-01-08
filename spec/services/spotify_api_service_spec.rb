require 'rails_helper'

describe SpotifyApiService do
  context 'class methods' do
    context '#create_playlist' do
      it 'creates a new playlist' do
        new_playlist = File.read('spec/fixtures/playlists/create_playlist.json')
        stub_request(:post, 'https://api.spotify.com/v1/users/1234/playlists')
          .with(
            body: '{"name":"test","public":true,"description":"Playlist created by FasTracks on Spotify API"}',
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'Bearer 1234',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Faraday v2.8.1'
            }
          )
          .to_return(status: 200, body: new_playlist, headers: {})

        playlist = SpotifyApiService.create_playlist('1234', '1234', 'test')
        expect(playlist).to be_a(Hash)
        expect(playlist).to have_key(:data)
        expect(playlist[:data]).to be_a(Hash)
        expect(playlist[:data]).to have_key(:id)
        expect(playlist[:data][:id]).to be_a(String)
      end
    end

    context '#add_tracks_to_playlist' do
      it 'can add tracks to an existing playlist' do
        response_stub = File.read('spec/fixtures/playlists/add_tracks_to_playlist.json')

        stub_request(:post, 'https://api.spotify.com/v1/playlists/1234/tracks')
          .with(
            body: '{"uris":"spotify:track:4QeoDcR16IHpmmgFGQDrCp"}',
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'Bearer 1234',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Faraday v2.8.1'
            }
          )
          .to_return(status: 200, body: response_stub, headers: {})
        playlist = SpotifyApiService.add_tracks_to_playlist('1234', '1234', 'spotify:track:4QeoDcR16IHpmmgFGQDrCp')
        expect(playlist).to be_a(Hash)
        expect(playlist).to have_key(:data)
        expect(playlist[:data]).to be_a(Hash)
        expect(playlist[:data]).to have_key(:snapshot_id)
      end
    end

    context '#get_song_recommendations' do
      it 'can get song recommendations' do
        response_stub = File.read('spec/fixtures/songs_selection/songs.json')

        stub_request(:get, "https://api.spotify.com/v1/recommendations?limit=10&seed_genres=pop&target_tempo=140").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer 1234',
          'User-Agent'=>'Faraday v2.8.1'
           }).
         to_return(status: 200, body: response_stub, headers: {})
        songs = SpotifyApiService.get_song_recommendations('1234', 'pop', '140', '10')
        expect(songs).to be_a(Hash)
        expect(songs).to have_key(:data)
        expect(songs[:data]).to be_a(Hash)
        expect(songs[:data]).to have_key(:tracks)
        expect(songs[:data][:tracks]).to be_a(Array)
        expect(songs[:data][:tracks].first).to have_key(:uri)
      end
    end

    context '#get_user' do
      it 'retrieves a user ID' do
        user = File.read('spec/fixtures/user/user.json')
        
        stub_request(:get, "https://api.spotify.com/v1/me").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'Authorization'=>'Bearer 1234',
         'User-Agent'=>'Faraday v2.8.1'
          }).
        to_return(status: 200, body: user, headers: {})

        user_id = SpotifyApiService.get_user('1234')
        expect(user_id).to be_a(Hash)
        expect(user_id).to have_key(:data)
        expect(user_id[:data]).to be_a(Hash)
        expect(user_id[:data]).to have_key(:id)
      end
    end

    context '#get_genres' do
      it 'retrieves a list of genres' do
        json_response = File.read('spec/fixtures/genre_requests/genres.json')

        stub_request(:get, 'https://api.spotify.com/v1/recommendations/available-genre-seeds')
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'Bearer 1234',
              'User-Agent' => 'Faraday v2.8.1'
            }
          )
        .to_return(status: 200, body: json_response, headers: {})

        genres = SpotifyApiService.get_genres('1234')
        expect(genres).to be_a(Hash)
        expect(genres).to have_key(:data)
        expect(genres[:data]).to be_a(Hash)
        expect(genres[:data]).to have_key(:genres)
      end
    end
  end
end
