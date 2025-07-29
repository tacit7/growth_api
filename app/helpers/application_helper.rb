# frozen_string_literal: true

module ApplicationHelper
  def event_badge_class(event_name)
    case event_name
    when 'Page View'
      'bg-blue-100 text-blue-800'
    when 'Click'
      'bg-green-100 text-green-800'
    when 'Login', 'Signup'
      'bg-purple-100 text-purple-800'
    when 'Logout'
      'bg-gray-100 text-gray-800'
    when 'Subscribe', 'Upgrade Plan'
      'bg-yellow-100 text-yellow-800'
    when 'Unsubscribe', 'Downgrade Plan'
      'bg-red-100 text-red-800'
    when 'Delete Account'
      'bg-red-100 text-red-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end