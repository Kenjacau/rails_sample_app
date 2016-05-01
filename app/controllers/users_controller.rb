class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    #debugger
  end
  
 def create
    @user = User.new(user_params)
    if @user.save
       flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
 end

  private
#Specify which parameters are required and whch ones are permitted
#Protect against mass assignment vulernabilities
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
