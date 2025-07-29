# frozen_string_literal: true

class SubscriptionService
  extend ServiceHelper

  def initialize(user)
    @user = user
  end

  def upgrade
    return false if @user.premium?

    @user.update(subscription_type: :premium)
  end

  def downgrade
    return false if @user.free?

    @user.update(subscription_type: :free)
  end
end
