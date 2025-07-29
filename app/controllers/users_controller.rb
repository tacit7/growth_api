# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :destroy]
  before_action :ensure_admin, only: [:index, :destroy]
  
  def index
    @users = User.order(created_at: :desc)
  end
  
  def show
    redirect_to profile_path
  end
  
  def profile
    @user = current_user
    current_user.log_event('Page View', {
      page_path: '/profile',
      referrer: request.referer
    })
  end
  

  
  def destroy
    if @user == current_user
      redirect_to users_path, alert: "You cannot delete your own account"
      return
    end
    
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully"
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def ensure_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied"
    end
  end
end
