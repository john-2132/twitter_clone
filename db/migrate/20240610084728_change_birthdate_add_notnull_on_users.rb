class ChangeBirthdateAddNotnullOnUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :birth_date, false
  end
end
