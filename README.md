# FasTracks README (BE)
FasTracks provides a streamlined approach to workout playlist generation. Once the user selects genre preference and workout type, they are provided with an optimized playlist using metadata from Spotify, and criteria held in the FasTracks backend.

The project follows service-oriented architecture (SOA) and is divided into two different repositories:
  - [FasTracks-Frontend](https://github.com/FasTracks/FasTracks-FE) 
  - [FasTracks-Backend](https://github.com/FasTracks/FasTracks-BE) (you are here)

# FasTracks BE

This application consists of two repositories that utilize Spotify's API to create playlists for workouts. I don’t like working out, but it’s more fun and I have a better workout when I have a good playlist. But I don’t always like making playlists either. 

This is the backend repository that interacts with the Spotify API and delivers playlist data to the front end application. [FasTracks-FE](https://github.com/FasTracks/FasTracks-FE) provides the backend with authentication and user playlist preferences. [FasTracks-BE](https://github.com/FasTracks/FasTracks-BE) takes that input and, based on the parameters, sends requests to Spotify to generate a playlist inside the user's Spotify account. FasTracks-BE returns the important playlist details to FasTracks-FE in JSON format so the user can enjoy their new playlist. 

## Getting Started

The fastest way to start working out using FasTracks is to visit our deployed app [here](https://fastracks-62267ab898ea.herokuapp.com/).

If you would like to run the application locally, you will need Rails 7.X.X and to clone both [FasTracks-FE](https://github.com/FasTracks/FasTracks-FE) and [FasTracks-BE](https://github.com/FasTracks/FasTracks-BE), since the application follows service-oriented architecture. Within each repo, follow the steps below. 

1. `bundle install`
2. `rails db:{drop,create}`
3. `bundle exec rspec` -- to see TDD in action
4. `rails server`

Then, in your browser, visit `localhost:3000` and follow the prompts on screen. 

*Due to development constraints from Spotify, FasTracks is currently limited to invite-only users. Please message one of our contributors with to be added to our list of approved users. Please be sure to include the email address associated with your Spotify account. Alternatively, users may create their own app through [Spotify's developer portal](https://developer.spotify.com/documentation/web-api/concepts/apps) and reconfigure the Client ID and Client Secret in their local copy of the FE repo.*

### Prerequisites

For the fastest startup, we recommend visiting the deployed app [here](https://fastracks-62267ab898ea.herokuapp.com/).

However, if you prefer to get your hands dirty and understand our app, feel free to fork and clone this repo as well as [FasTracks-BE](https://github.com/FasTracks/FasTracks-BE). We recommend a basic understanding of the following concepts before diving in to our code:

- Ruby on Rails Applications
- Service oriented architecture
- Oauth 2.0
- Spotify API

Requirements for the software and other tools to build, test and push 
- Rails 7.X
- Ruby 3.2.2
- Spotify API V1

## Notes on Data Flow

### FasTracks FE x FasTracks FE

Only one endpoint is exposed for FasTracks BE: `/api/v1/playlists`. The BE receives proper authentication and playlist criteria, an BE makes a `POST` request to the Spotify API and a playlist JSON is returned. 

FasTracks FE sends the user's auth token and playlist preferences in the parameters of the POST request to the FasTracks BE endpoint `/api/v1/playlists`

Example Request: `HTTP://<backendurl/path>?code=<USER_ACCESS_TOKEN>&genre=<SELECTED_GENRE>&workout=<SELECTED_WORKOUT>`

FasTracks BE then returns playlist details to FasTracks FE in JSON Format including:
 - Playlist name
 - Playlist Spotify URL
 - Songs Album Artwork URL
 - Songs track title
 - Songs Artist
 - Playlist song count

Visit this link for a [sample return](https://github.com/FasTracks/FasTracks-FE/blob/main/spec/support/fixtures/fastracks/playlist.json)

### FasTracks FE x [Spotify API](https://developer.spotify.com/)

A `POST` request to the FasTracks BE playlist endpoint results in four calls from FasTracks BE to Spotify:
  - `GET` `/recommendations` sends the playlist's song preferences including BPM, Genre, and count. Among other data it returns each track's unique URI.
  - `GET` `/me` retrieves the current user's details, including user ID
  - `POST` `/users/<USER_ID>/playlists` creates a new, empty playlist for the user
  - `POST` `/playlists/<PLAYLIST_ID>/tracks` the track URI's are sent as an array, and the playlist details are returned.

Each of these requests includes the Auth code in the header. For examples of the returns of each of these requests, visit this [folder](https://github.com/FasTracks/FasTracks-BE/tree/main/spec/fixtures) of the FasTracks BE repo. 

### Installing

- Fork and clone these repos
  - [FasTracks-Frontend](https://github.com/FasTracks/FasTracks-FE) 
  - [FasTracks-Backend](https://github.com/FasTracks/FasTracks-BE) (you are here)

`bundle install`<br>
`rails db:{create,migrate}`<br>

Gems Included: 

- gem "pry-rails"
- gem "rspec-rails"
- gem "factory_bot_rails"
- gem "faker"
- gem "shoulda-matchers"
- gem "capybara"
- gem "faraday"
- gem "webmock"
- gem "vcr"

End with an example of getting some data out of the system or using it
for a little demo


## Running the tests

Follow commands below to run the app test suite. 

`bundle exec rspec`

### Sample Tests

See below for an example test from our suite. This is part of the `spotify_facade_spec` that can be found under the `spec/facades` directory in the repo.

Tests below include many of the pivotal operations of our application, including: 
- Retrieving User ID
- Creating a playlist for the user
- Finding songs that match the workout
- Populating the playlist

```
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
```

## Deployment

This project is deployed using heroku [here](https://fastracks-62267ab898ea.herokuapp.com/) 
  
<img src="https://logowik.com/content/uploads/images/heroku8748.jpg" alt="drawing" width="100"/>

## Built With

- Spotify API
- Ruby on Rails
- Faraday
- Webmock

<img src="https://mikewilliamson.files.wordpress.com/2010/05/rails_on_ruby.jpg" alt="drawing" width="75"/>
<img src="https://storage.googleapis.com/pr-newsroom-wp/1/2018/11/Spotify_Logo_CMYK_Green.png" width="75"/>

## Contributing

Contributions are welcome and can be submitted by pull request. 

## Versioning

The current version (V1) of our application is live here on github. 

## Authors

  - **Edward Avery Rodriguez** - *[LinkedIn](https://www.linkedin.com/in/edward-avery-rodriguez/), [GitHub](https://github.com/TheAveryRodriguez)* 
  - **Kameron Kennedy** - *[LinkedIn](https://www.linkedin.com/in/kameron-kennedy-pe/), [GitHub](https://github.com/kameronk92)* 
  - **Scott DeVoss** - *[LinkedIn](https://www.linkedin.com/in/scott-devoss/), [GitHub](https://github.com/scottdevoss)* 
  - **Sooyung Kim** - *[LinkedIn](https://www.linkedin.com/in/sooyung-kim/), [GitHub](https://github.com/skim1027)* 
  - **Taylor Pubins** - *[LinkedIn](https://www.linkedin.com/in/trpubins/), [GitHub](https://github.com/trpubz)* 

## License

This project is not licensed and is open source. 

## Acknowledgments

  - Technical direction and consultation provded by [Jamison Ordway](https://github.com/jamisonordway) and [Chris Simmons](https://github.com/cjsim89)
  - This project completed by Mod 3 students at [Turing School of Software and Design](https://turing.edu/)
  - Little Caesar's Pizza for providing the most calories per dollar within 0.5 miles of [kameronk92's](https://github.com/kameronk92) house
