require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  erb(:home)
end

get("/umbrella") do
 erb(:umbrella)  
end


get "/process_umbrella" do

  @user_location = params.fetch("user_location")
  user_location = @user_location
  location = user_location.gsub(" ", "")
  
  maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + location + "&key="+ENV.fetch("GMAPS_KEY") 
  resp = HTTP.get(maps_url)
  raw_response = resp.to_s
  parsed_response = JSON.parse(raw_response)
  results = parsed_response.fetch("results")
  first_result = results.at(0)
  geo = first_result.fetch("geometry")
  loc = geo.fetch("location")
  lat = loc.fetch("lat")
  lng = loc.fetch("lng")

  @lats = lat
  @lngs = lng
  lats = lat.to_s
  lngs = lng.to_s

  pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

  pirate_weather_url = "https://api.pirateweather.net/forecast/"+ pirate_weather_api_key + "/" +lats +"," +lngs
  raw_response = HTTP.get(pirate_weather_url)
  parsed_response = JSON.parse(raw_response)
  currently_hash = parsed_response.fetch("currently")
  
  @current_temp = currently_hash.fetch("temperature").round() 
  @summary = currently_hash.fetch("summary")

  if (currently_hash.fetch("summary") == "Clear")
    @umbrella = "No need for an umbrella today!"
  else
    @umbrella = "Better take an umbrella today!"

  end

  erb(:process_umbrella)
end

get '/message' do
  erb(:message)
end

post '/process_single_message' do
  erb(:message_responce)
end

get '/chat' do
  erb(:chat)
end


post '/add_message_to_chat' do
 erb(:chat_responce)
end

post '/clear_chat' do
  "Hello World"
end
