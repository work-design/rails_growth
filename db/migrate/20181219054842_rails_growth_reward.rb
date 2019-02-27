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
      t.references :user #2019.2.15
      t.references :source, polymorphic: true
      t.string :type
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :royalty_amount, precision: 10, scale: 2
      t.decimal :reward_amount, precision: 10, scale: 2
      t.decimal :profit_amount, precision: 10, scale: 2
      t.timestamps
    end

    # 2019.2.20
    create_table :praise_users do |t|
      t.references :user
      t.references :reward
      t.references :entity, polymorphic: true
      t.decimal :amount, precision: 10, scale: 2
      t.integer :position, default: 1
      t.timestamps
    end

    create_table :reward_expenses do |t|
      t.references :reward
      t.references :aim
      t.references :user
      t.decimal :amount, precision: 10, scale: 2
      t.timestamps
    end

    create_table :gifts do |t|
      t.string :name
      t.string :code
      t.integer :amount
      t.integer :praise_incomes_count, default: 0
      t.timestamps
    end

  end
end
