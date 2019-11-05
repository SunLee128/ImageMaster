require 'bcrypt'
require 'sinatra/reloader'
require 'pg'

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

# def logged_in? #predicate method - return a boolean
#     return !!current_user #truthy
#     #     return true
#     # else 
#     #     return false
#     # end
# end

def current_user
    find_one_user(session[:user_id])
end

