class AddNotNullConstraintToWorksTitle < ActiveRecord::Migration[8.1]
  def change
    change_column_null :works, :title, false
  end
end
