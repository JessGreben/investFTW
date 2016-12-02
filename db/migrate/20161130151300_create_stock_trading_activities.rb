class CreateStockTradingActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_trading_activities do |t|
      t.belongs_to :company
      t.date :date
      t.decimal :open
      t.decimal :high
      t.decimal :low
      t.decimal :close
      t.integer :volume, :limit => 8

      t.timestamps
    end
  end
end
