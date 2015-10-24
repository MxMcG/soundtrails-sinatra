require 'httparty'


get '/users/:id/maps' do
  redirect '/' unless auth_logged_in?
  @user = auth_current_user
  @maps = Map.where(user_id: params[:id])
  erb :'users/profile'
end

get '/users/:id/maps/new' do
  @user = auth_current_user
  if request.xhr?
    erb :'maps/create_map', layout: false
  end
end

post '/users/:id/maps' do
  get_user
  if request.xhr?
    p "params: #{params}"
    @map = Map.create(center_lat: params[:map_lat], center_lng: params[:map_lng], artist: params[:map_title], user_id: get_user.id)
    p "&" * 80



  else
    erb :'maps/add_map', layout: false
  end
  # redirect "/maps/#{@map.id}"
end

get '/maps/:id' do
  map = Map.find(params[:id])
  if request.xhr?
    return {center_lng: map.center_lng, center_lat: map.center_lat, artist: map.artist}.to_json
  end
  erb :"/maps/view_map", locals: {map: map}
end

delete '/maps/:id' do
  map = Map.find(params[:id]);
  map.destroy
  redirect "users/#{map.user.id}/maps"
end