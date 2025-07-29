# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
    rescue_from JSON::ParserError, with: :handle_json_error
  end

  private

  def handle_not_found(exception)
    render json: { 
      error: 'Resource not found',
      details: exception.message 
    }, status: :not_found
  end

  def handle_invalid_record(exception)
    render json: { 
      error: 'Validation failed',
      details: exception.record.errors.full_messages 
    }, status: :unprocessable_entity
  end

  def handle_parameter_missing(exception)
    render json: { 
      error: 'Missing required parameter',
      details: exception.message 
    }, status: :bad_request
  end

  def handle_json_error(exception)
    render json: { 
      error: 'Invalid JSON format',
      details: exception.message 
    }, status: :bad_request
  end
end
