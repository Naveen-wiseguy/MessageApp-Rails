class UsersController < ApplicationController
	def new
		@user=User.new
	end

	def create
		@user=User.new(users_params)
		if @user.save
			redirect_to root_path
		else
			redirect_to new_user_path,danger: "Unable to add user"
		end
	end

	def login
	end
	
	def destroy
	end

	def auth
		user_name=params[:user_name]
		user=User.find_by(user_name: user_name)
		if(user!=nil)
			if user.password==params[:password]
				session[:loggedin]=true
				session[:userid]=user.id 
				redirect_to root_path
			else	redirect_to login_path, danger: "Invalid details"
			end
		else
			redirect_to login_path, danger: "Invalid user"
		end
	end

	def home
		if (session[:loggedin]!=true) then redirect_to login_path
		else
			@user=User.find(session[:userid])
		end
	end

	def show
		if session[:loggedin]!=true then redirect_to lopgin_path
		elsif session[:userid]==params[:id]
			@user=User.find(session[:userid])
		else
			redirect_to root_path
		end
	end

	def sendmsg
		if session[:loggedin]!=true then redirect_to lopgin_path end
		@message=Message.new
		@message.sender=User.find(session[:userid])
		@message.recipient=User.find(params[:user][:id])
		@message.body=params[:body]
		if @message.save then @response="Success"
		else
			@response="Unable to send"
		end
	end
	
	def logout
		session[:loggedin]=false
		session[:userid]=nil
		redirect_to login_path
	end

	def refreshmsg
		@user=User.find(session[:userid])
		respond_to do |format|
			format.html {render :layout =>false}
		end
	end

	def refreshsent
		@user=User.find(session[:userid])
		respond_to do |format|
			format.html {render :layout =>false}
		end
	end

	private
	def users_params
		params.require(:user).permit(:name,:user_name,:password)
	end

end
