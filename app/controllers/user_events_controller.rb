# frozen_string_literal: true

class UserEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    @events = @user.event_logs
                   .includes(:user)
                   .recent
                   .page(params[:page])
                   .per(params[:per_page] || 25)

    # Apply filters if provided
    @events = @events.by_event_type(EventLog::EVENT_TYPES[params[:event_type]]) if params[:event_type].present?
    
    if params[:date_from].present? && params[:date_to].present?
      @events = @events.for_date_range(Date.parse(params[:date_from]), Date.parse(params[:date_to]))
    end

    @event_types = EventLog::EVENT_TYPE_NAMES.values
    @selected_event_type = params[:event_type]
    @date_from = params[:date_from]
    @date_to = params[:date_to]

    respond_to do |format|
      format.html
      format.json { render json: events_json_response }
    end
  end

  def show
    @event = @user.event_logs.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render json: serialize_event(@event) }
    end
  end

  private

  def set_user
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    
    # Ensure users can only see their own events unless admin
    unless current_user.admin? || @user == current_user
      redirect_to root_path, alert: 'Access denied'
    end
  end

  def events_json_response
    {
      events: @events.map { |event| serialize_event(event) },
      pagination: {
        current_page: @events.current_page,
        per_page: @events.limit_value,
        total_count: @events.total_count,
        total_pages: @events.total_pages
      },
      filters: {
        event_types: @event_types,
        selected_event_type: @selected_event_type,
        date_from: @date_from,
        date_to: @date_to
      }
    }
  end

  def serialize_event(event)
    {
      id: event.id,
      event_type: event.event_name,
      metadata: event.metadata,
      occurred_at: event.occurred_at.strftime('%Y-%m-%d %H:%M:%S'),
      ip_address: event.ip_address,
      user_agent: event.user_agent&.truncate(100)
    }
  end
end