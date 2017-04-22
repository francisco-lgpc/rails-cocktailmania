class ChangeDataTypeForDescription < ActiveRecord::Migration[5.0]
 def self.up
    change_table :doses do |t|
      t.change :description, :string
    end
  end
  def self.down
    change_table :doses do |t|
      t.change :description, :text
    end
  end
end
