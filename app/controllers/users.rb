get '/login' do
  if request.xhr?
    erb :'users/login', layout: false
  end
end

post '/login' do
  @user = User.find_by(:username => params[:username])

  if @user && @user.password == params[:password]
    auth_login(@user)
    redirect "/users/#{@user.id }/maps"
  else
    @form_error = 'Unable to log you in'
    erb :'users/login'
  end

end

get '/register' do
  @user = User.new
  if request.xhr?
    erb :'users/register', layout: false
  end
end

post '/register' do
  @user = User.new
  @user.username = params[:username]
  @user.email = params[:email]
  @user.password = params[:password]

  if @user.save && params[:password] == params[:password_confirmation]
    auth_login(@user)
    p "&" * 100
    redirect "/users/#{@user.id}/maps"
  else
    @form_error = 'Unable to register you'
    erb :'users/register'
  end

end

get '/logout' do
  auth_logout
  redirect '/'
end

