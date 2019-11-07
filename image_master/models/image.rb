require 'bcrypt'
require 'sinatra/reloader'
require 'pg'
require_relative '../main'

def analyze_image(img_url)
    # net/http get with dynamic parameters
    uri = URI('https://australiaeast.api.cognitive.microsoft.com/vision/v2.0/analyze')
    uri.query = URI.encode_www_form({
        # Request parameters
       'visualFeatures' => 'Categories, Description',
        'details' => 'Celebrities',
        'language' => 'en'
      })
    
    request = Net::HTTP::Post.new(uri.request_uri)
      
    # Request headers
    # Replace <Subscription Key> with your valid subscription key.
    request['Ocp-Apim-Subscription-Key'] = ENV['AZURE_API_KEY']
    request['Content-Type'] = 'application/json'
      
    request.body =
        "{\"url\": \"#{img_url}\"}"
      
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
    search=response.body
    @data = JSON.parse(search)
    if @data["categories"].empty?
      @name = ""
      @name_score = ""
    else
      @name = @data["categories"][0]["name"]
      @name_score = @data["categories"][0]["score"]
    end

    @tags = @data["description"]["tags"]
    
    if @data["description"]["captions"].empty?
      @captions = ""
      @confidence = ""
    else
      @captions = @data["description"]["captions"][0]["text"]
      @confidence = @data["description"]["captions"][0]["confidence"]
    end
end

def create_image(userid,name,image_url,tags,caption)
    sql = "insert into images (userid,name,image_url,tags,caption)"
    sql += "values (#{userid},'#{name}','#{image_url}', ARRAY[#{tags.map {|e| "'#{e}'"}.join(",")}],'#{caption}');"
    return run_sql(sql)
end
   
def find_images_by_user(userid)
    return run_sql("select * from images where userid = #{userid};")
end

def find_image_by_url(url)
    return run_sql("select * from images where image_url = #{url};")
end

def search_image_by_tag(keyword,userid)
    return run_sql("select * from images where '#{keyword.downcase}'=any(tags) and userid=#{userid};")
end
  