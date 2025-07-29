# frozen_string_literal: true

class AnalyticsService
  def self.user_engagement_score(user)
    new.user_engagement_score(user)
  end

  def self.conversion_funnel
    new.conversion_funnel
  end

  def self.user_growth_data(days: 30)
    new.user_growth_data(days)
  end

  def user_engagement_score(user)
    events = user.events.where(occurred_at: 1.month.ago..)
    return 0 if events.empty?
    
    # Weight different event types
    weights = { 
      page_view: 1, click: 2, login: 3, 
      subscribe: 10, upgrade_plan: 8, profile_updated: 5 
    }
    
    events.sum { |event| weights[event.event_type.to_sym] || 1 }
  end
  
  def conversion_funnel
    signups = Event.where(event_type: :signup).count
    subscriptions = Event.where(event_type: :subscribe).count
    
    {
      signups: signups,
      subscriptions: subscriptions,
      conversion_rate: signups > 0 ? (subscriptions.to_f / signups * 100).round(2) : 0
    }
  end

  def user_growth_data(days)
    start_date = days.days.ago.to_date
    User.where(created_at: start_date..).group_by_day(:created_at).count
  end

  def retention_rate(cohort_days: 30)
    cohort_start = cohort_days.days.ago.to_date
    cohort_users = User.where(created_at: cohort_start.beginning_of_day..cohort_start.end_of_day)
    return 0 if cohort_users.empty?

    active_users = cohort_users.joins(:events)
                              .where(events: { occurred_at: 7.days.ago.. })
                              .distinct.count

    (active_users.to_f / cohort_users.count * 100).round(2)
  end
end
