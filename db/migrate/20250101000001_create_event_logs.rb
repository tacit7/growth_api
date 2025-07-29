class CreateEventLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :event_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :event_type, null: false
      t.jsonb :metadata, null: false, default: {}
      t.datetime :occurred_at, null: false

      t.timestamps
    end

    add_index :event_logs, :event_type
    add_index :event_logs, :occurred_at
    add_index :event_logs, [:user_id, :event_type]
    add_index :event_logs, [:user_id, :occurred_at]
  end
end
