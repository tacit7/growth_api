class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :event_type
      t.jsonb :event_data
      t.datetime :occurred_at
      t.string :ip_address
      t.text :user_agent

      t.timestamps
    end
    add_index :events, :event_type
    add_index :events, :occurred_at
    add_index :events, :ip_address
  end
end
