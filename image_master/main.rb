require 'sinatra'
require 'pg'
require 'bcrypt'
require 'net/http'
require 'json'

if settings.development?
  require 'sinatra/reloader'
  also_reload 'models/*'
  also_reload 'controller/*'
  require 'pry'
end

require_relative 'models/user'
require_relative 'models/image'
require_relative 'controller/login_controller'

enable :sessions  

def run_sql(sql)
  conn = PG.connect(ENV['DATABASE_URL']||{dbname: "imagemaster"})
  records = conn.exec(sql)
  conn.close
  return records
end

get '/' do
  erb :index
end

get '/analyse' do
  analyze_image(params[:userinput])
  if logged_in?
    create_image(session[:user_id],@name, params[:userinput],@tags, @captions )
  end
  erb :analyse
end

# click on a single movie - click on a single image
# post '/save_image' do
#   analyze_image(params[:userinput])
#   if logged_in?
#     unless find_image_by_url(params[:userinput])
#       create_image(session[:user_id],@name, params[:userinput],@tags, @captions )
#     end
#   end
# end 

get '/user_detail' do
  @images_by_user = find_images_by_user(session[:user_id])
  erb :user_detail
end

get '/image_filter' do
  @filtered_by_keyword = search_image_by_tag(params[:keyword],session[:user_id])
  erb :filter_results
end

# def filter_images(tag)
#   return run_sql(select * from images where tags = )
# end
# delete '/tag_delete' do
#   "hello delete"
# end

# def delete_tag(id)
#   return run_sql("delete from dishes where id = #{id};")
# end

# delete '/destroy_image' do
#   delete_image(params[:id])
#   redirect "/"
# end

