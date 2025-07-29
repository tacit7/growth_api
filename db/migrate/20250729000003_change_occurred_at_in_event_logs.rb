# frozen_string_literal: true

class ChangeOccurredAtInEventLogs < ActiveRecord::Migration[7.2]
  def change
    change_column_null :event_logs, :occurred_at, false
  end
end
