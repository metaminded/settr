class CreateSettings < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.string    'key'
      t.text      'value'
      t.string    'kind'
      t.boolean   'protected', default: false
      t.timestamps
    end

    add_index :settings, :key, unique: true
  end

  def down
    drop_table :settings
  end
end
