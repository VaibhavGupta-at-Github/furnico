class UsersController < ApplicationController
  before_action :set_user, only: [:show,:edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update ]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @users= User.all.paginate(page: params[:page], per_page: 3)
  end

  def new 
    @user= User.new
  end

  def create 
    @user= User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] ="User has been successfully created."
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User Info has been updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    session[:user_id] = nil
    flash[:notice] = "Your Furnico account has been deleted and cart items have been cleared."
    redirect_to users_path
  end
  
  private 
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email , :password )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user
      flash[:alert] = "You can edit your own account."
      redirect_to @user
    end
  end
end
