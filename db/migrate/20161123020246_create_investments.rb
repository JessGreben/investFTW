class CreateInvestments < ActiveRecord::Migration[5.0]
  def change
    create_table :investments do |t|
      t.decimal :initInvestment

      t.timestamps
    end
  end
end
