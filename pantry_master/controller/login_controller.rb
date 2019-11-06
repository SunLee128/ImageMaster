require 'bcrypt'
require_relative '../models/user'
require_relative '../models/recipe'
require 'pry'

get '/user_login' do
    erb :user_login
end

post '/user_login' do
    # check record exist in the db
    user = find_user_by_email(params[:email])
    # binding.pry
    # check password is valid for that record
    
    if BCrypt::Password.new(user["password_digest"]) == params[:password]
        # write down id of login user (we usually say create a session for the user)
        session[:user_id] = user["id"] # single source of truth
        # redirect to secret location, just home page for now
        redirect "/user_detail" # its up to you prob user dashboard or profile page
    else
        return "Your email or password is incorrect."
    end
    erb :user_login
end

delete '/user_logout' do
    session[:user_id] = nil
    redirect "/"
end

get '/user_signup' do
    erb :user_signup
end

post '/user_signup' do
    create_user(params[:email],params[:password])
    redirect'/'
end

get '/user_detail' do
    erb :user_detail
end