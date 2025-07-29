# frozen_string_literal: true

class CreateEventLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :event_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :event_type, null: false
      t.jsonb :metadata, default: {}
      t.string :ip_address
      t.string :user_agent
      t.datetime :occurred_at, null: false
      
      t.timestamps
    end
    
    # Add indexes for efficient querying
    add_index :event_logs, :event_type
    add_index :event_logs, :occurred_at
    add_index :event_logs, [:user_id, :occurred_at]
    add_index :event_logs, [:event_type, :occurred_at]
    add_index :event_logs, :metadata, using: :gin
  end
end
