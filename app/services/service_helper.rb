# frozen_string_literal: true

module ServiceHelper
  def call(*args)
    new(*args).call
  end

  def upgrade(user)
    new(user).upgrade
  end

  def downgrade(user)
    new(user).downgrade
  end
end
