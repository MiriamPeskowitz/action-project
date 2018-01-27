require './config/environment'

class ApplicationController < Sinatra::Base

  enable :sessions
  set :session_secret, "action_secret" 	
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

#show homepage 
  	get "/" do
  		session.clear
      @actions = Action.all #I put this here to bring data to the opening page. 
  	  erb :'index'
  	end

    # List of people signed up -- not needed. 
    # get '/citizens' do
    #   @citizens = Citizen.all
    #   erb :'citizens/index'
    # end
# #1 send SIGNUP form to browser
#     get '/citizens/signup' do
    
#       if logged_in? 
#         redirect to '/actions' 
#       else
#         erb :'citizens/signup'
#       end 
#     end
# #2 get SIGNUP data from form and CREATE citizen entry in db
#     post '/citizens/signup' do 
#       if params[:username] == '' ||  params[:email] ==  "" || params[:password] == ""
#         flash[:notice] = "Fill in all the fields, okay?"
#         redirect to '/citizens/signup'
#       else
#         @citizen = Citizen.create(:username => params[:username], :email => params[:email], :password => params[:password])
#         session[:user_id] = @citizen.id
#         redirect to '/actions'
#       end 
#     end 

 #  get '/citizens/login' do
    
 #      if !logged_in?
 #         erb :'citizens/login'
 #      else
 #         redirect to '/actions'
 #      end 
 #    end   

 # #4 Read LOGIN data from form, send to db/sessions 
 #    post '/citizens/login' do
 #      redirect to '/actions' if logged_in?
 #      @citizen = Citizen.find_by(username: params[:username])
      
 #      if @citizen && @citizen.authenticate(params[:password])
 #         session[:user_id] = @citizen.id
 #         redirect to '/actions'
 #      else
 #          flash[:notice] = "You've got a lot on your mind, but we do need a valid Username and Password."
 #          redirect to '/'
 #      end
 #    end 
helpers do
      def logged_in?
        !!session[:user_id]
      end

      def current_user
         Citizen.find(session[:user_id])
      end
    end 

end 
