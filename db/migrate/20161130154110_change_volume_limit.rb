class ChangeVolumeLimit < ActiveRecord::Migration[5.0]
  def change
    change_column :stock_trading_activities, :volume, :integer, :limit => 8
  end
end
