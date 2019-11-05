require 'sinatra'
require 'httparty'
require 'pg'
require 'bcrypt'

if settings.development?
  require 'sinatra/reloader'
  also_reload 'models/*'
  also_reload 'controller/*'
  require 'pry'
end

# require_relative 'models/user'
# require_relative 'models/recipe'
require_relative 'controller/login_controller'
require_relative 'controller/recipe_controller'

key = ENV['EDAMAM_RECIPE_API_KEY']
id = ENV['EDAMAM_RECIPE_API_ID']

enable :sessions  

def run_sql(sql)
  conn = PG.connect(ENV['DATABASE_URL']||{dbname: "pantrymaster"})
  records = conn.exec(sql)
  conn.close
  return records
end


get '/' do
  # @recipes = all_dishes()
  erb :index
end

get '/search' do
  @search = HTTParty.get("https://api.edamam.com/search?q=#{params[:keyword]}&app_id=#{id}&app_key=#{key}&from=0&to=30")
  @keyword = params[:keyword]
  erb :search
end

# =====users=======================
def all_users
  return run_sql("select * from users;")
end

def find_one_user(id)
  return nil unless id #guard condition- early return
  return run_sql("select * from users where id = #{id};").first
end

def find_user_by_email(email)
  return run_sql("select * from users where email = '#{email}';").first
end

def create_user(email,password)
  password_digest = BCrypt::Password.create(password)
  sql = "insert into users(email,password_digest)"
  sql += "values ('#{email}','#{password_digest}');"
  return run_sql(sql)
end
# =======users==========================

# get '/movie' do
#   # check moves db
#   movie = find_movie(params[:movie])
#   # if movie is not on db, make api call
#   if movie == nil
#     result = HTTParty.get("http://omdbapi.com/?t=#{params[:movie]}&apikey=#{key}")
#     @title = result["Title"]
#     @year = result["Year"]
#     @img = result["Poster"]
#     @genre = result["Genre"]
#     @plot = result["Plot"]
#     @imdb_rating = result["imdbRating"]
#     # save to db
#     save_movie(@title,@year.to_i,@img,@genre,@plot,@imdb_rating)
#   # else search it from db
#   else
#     @title = movie["title"]
#     @year = movie["year"]
#     @img = movie["img"]
#     @genre = movie["genre"]
#     @plot = movie["plot"]
#     @imdb_rating = movie["imdb"]
#   end
#   erb :movie
# end

# get '/details' do
#   redirect '/' unless logged_in?
#   @dish = find_one_dish(params[:id])
#   erb :details
# end

# get '/new_item' do
#   erb :new_dish
# end

# post '/create_item' do
#   create_dish(params[:name], params[:image_url])
#   redirect "/"
# end

# delete '/destroy_item' do
#   delete_dish(params[:id])
#   redirect "/"
# end

# get '/edit' do
#   @dish = find_one_dish(params[:id])
#   erb :edit
# end

# patch '/update_itme' do
#   update_dish(params[:name], params[:image_url],params[:id])
#   redirect "/details?id=#{params[:id]}"
# end


# get '/users' do
#   @users = all_users()
#   erb :all_users
# end

# get '/user_details' do
#   @user = find_one_user(params[:id])
#   erb :show_user
# end

def create_user(email,password)
    password_digest = BCrypt::Password.create(password)
    sql = "insert into users(email,password_digest)"
    sql += "values ('#{email}','#{password_digest}');"
    return run_sql(sql)
end