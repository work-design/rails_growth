class RailsGrowthReward < ActiveRecord::Migration[5.2]
  def change

    create_table :rewards do |t|
      t.references :entity, polymorphic: true
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :income_amount, precision: 10, scale: 2
      t.decimal :expense_amount, precision: 10, scale: 2
      t.decimal :max_piece, precision: 10, scale: 2
      t.decimal :min_piece, precision: 10, scale: 2
      t.integer :lock_version
      t.integer :incomes_count
      t.integer :expenses_count
      t.datetime :start_at
      t.datetime :finish_at
      t.boolean :enabled, default: true
      t.timestamps
    end

    create_table :reward_incomes do |t|
      t.references :reward
      t.string :type
      t.decimal :amount, precision: 10, scale: 2
      t.timestamps
    end

    create_table :reward_expenses do |t|
      t.references :reward
      t.references :aim
      t.references :user
      t.decimal :amount, precision: 10, scale: 2
      t.timestamps
    end

    create_table :coin_logs do |t|
      t.references :user
      t.references :source, polymorphic: true
      t.string :title
      t.string :tag_str
      t.decimal :amount, precision: 10, scale: 2
      t.timestamps
    end

    create_table :coins do |t|
      t.references :user
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :income_amount, precision: 10, scale: 2
      t.decimal :expense_amount, precision: 10, scale: 2
      t.integer :position, default: 1
      t.timestamps
    end

    create_table :coin_cashes do |t|
      t.references :user
      t.decimal :coin_amount, precision: 10, scale: 2
      t.decimal :cash_amount, precision: 10, scale: 2
      t.timestamps
    end

  end
end
