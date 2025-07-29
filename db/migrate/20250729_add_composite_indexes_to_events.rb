# frozen_string_literal: true

class AddCompositeIndexesToEvents < ActiveRecord::Migration[7.2]
  def change
    add_index :events, [:user_id, :event_type, :occurred_at], name: 'index_events_on_user_event_time'
    add_index :events, [:event_type, :occurred_at], name: 'index_events_on_type_time'
    add_index :events, [:occurred_at, :event_type], name: 'index_events_on_time_type'
  end
end
