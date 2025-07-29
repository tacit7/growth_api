# frozen_string_literal: true

class AboutController < ApplicationController
  # Cache the about page for 1 hour with proper headers
  def index
    # Browser and proxy caching
    expires_in 1.hour, public: true
    
    # Check if content is fresh (returns early if 304)
    return if fresh_when(etag: 'about-page-v1', last_modified: 1.hour.ago, public: true)
    
    # Rails application caching
    @cached_content = Rails.cache.fetch('about_page_content:v1', expires_in: 1.hour) do
      render_to_string 'about/index', layout: false
    end
    
    render html: @cached_content.html_safe
  end
  
  # Method to invalidate cache (for admin or deployment scripts)
  def self.invalidate_cache
    Rails.cache.delete('about_page_content:v1')
  end
end
