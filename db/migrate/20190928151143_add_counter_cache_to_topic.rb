class AddCounterCacheToTopic < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :impressions_count, :integer, default: 0
  end
end
 
