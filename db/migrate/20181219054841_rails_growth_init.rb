class RailsGrowthInit < ActiveRecord::Migration[5.2]
  def change

    create_table :aims do |t|
      t.string :name
      t.integer :task_point, default: 0
      t.integer :reward_point, default: 0
      t.string :unit
      t.integer :score
      t.string :repeat_type
      t.boolean :verbose
      t.timestamps
    end

    create_table :aim_codes do |t|
      t.references :aim
      t.string :controller_path
      t.string :action_name
      t.string :code, null: false
      t.timestamps
    end

    create_table :aim_users do |t|
      t.references :aim
      t.references :user
      t.string :serial_number
      t.string :state
      t.integer :aim_entities_count, default: 0
      t.timestamps
    end

    create_table :aim_entities do |t|
      t.references :aim
      t.references :user
      t.references :entity, polymorphic: true
      t.integer :present_point
      t.string :state
      t.string :serial_number
      t.datetime :last_access_at
      t.inet :ip
      t.integer :aim_logs_count, default: 0
      t.references :reward_expense
      t.decimal :reward_amount, precision: 10, scale: 2
      t.timestamps
    end

    create_table :aim_logs do |t|
      t.references :aim
      t.references :user
      t.references :entity, polymorphic: true
      t.inet :ip
      t.string :code
      t.boolean :rewarded
      t.datetime :created_at, null: false
    end

  end
end
