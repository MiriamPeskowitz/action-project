require './config/environment'

class ApplicationController < Sinatra::Base

  enable :sessions
  set :session_secret, "action_secret" 	

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

#show homepage 
	get "/" do
		session.clear
	  erb :'index'
	end

    get '/citizens' do
      @citizens = Citizen.all
      erb :'citizens/index'
    end

  	# get '/citizens/:slug' do
  	# 	@citizen = Citizen.find_by_slug(params[:slug])
  	# 	erb :'citizens/show'
  	# end 

# Citizen.create(:username => "leo", :email => "leo@email.com", :password => "leo")

#1 send SIGNUP form to browser
  	get '/citizens/signup' do
  		if logged_in? 
  			redirect to '/actions' 
  		else
  			erb :'citizens/signup'
  		end 
  	end

#2 get SIGNUP data from form and CREATE citizen entry in db
  	post '/citizens/signup' do 
  		if params[:username] == '' ||  params[:email] ==  "" || params[:password] == ""
  			redirect to '/citizens/signup'
  		else
  			@citizen = Citizen.create(:username => params[:username], :email => params[:email], :password => params[:password])
        session[:user_id] = @citizen.id
  			redirect to '/actions'
  		end 
  	end 

 #3 Send LOGIN form to browser
  	get '/citizens/login' do
  		if !logged_in?
  			erb :'citizens/login'
  		else
  			redirect to '/actions'
  		end 
  	end 	

 #4 Read LOGIN data from form, send to db/sessions 
   	post '/citizens/login' do
      redirect to '/actions' if logged_in?
      @citizen = Citizen.find_by(username: params[:username])
      
  	 	if @citizen && @citizen.authenticate(params[:password])
  	 		 session[:user_id] = @citizen.id
  		   redirect to '/actions'
  	  else
  	 	    redirect to '/'
  	  end
   	end 

  #5 LOGOUT/delete/clear session 
  	get '/citizens/logout' do
  		if logged_in?
  			session.clear
  			redirect to '/citizen/login'
  		else 
  			redirect to '/citizen/login'
  		end 
  	end 


    helpers do
      def logged_in?
        !!session[:user_id]
      end

      def current_user
         Citizen.find(session[:user_id])
      end
    end 

end 
