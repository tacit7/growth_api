# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :destroy, :events]
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
  
  def events
    @user = params[:id] ? User.find(params[:id]) : current_user
    
    # Ensure users can only see their own events unless they're admin
    unless current_user.admin? || @user == current_user
      redirect_to profile_path, alert: "Access denied"
      return
    end
    
    @events = @user.event_logs.includes(:user).recent
    
    # Apply filters if present
    if params[:event_type].present?
      @events = @events.where(event_type: params[:event_type])
    end
    
    if params[:start_date].present?
      @events = @events.where('occurred_at >= ?', Date.parse(params[:start_date]))
    end
    
    if params[:end_date].present?
      @events = @events.where('occurred_at <= ?', Date.parse(params[:end_date]).end_of_day)
    end
    
    # Paginate if Kaminari is available
    @events = @events.page(params[:page]).per(25) if defined?(Kaminari)
    
    # Log the page view
    current_user.log_event('Page View', {
      page_path: request.path,
      referrer: request.referer,
      target_user: @user.id
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
