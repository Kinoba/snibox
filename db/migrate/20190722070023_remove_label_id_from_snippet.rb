class RemoveLabelIdFromSnippet < ActiveRecord::Migration[5.2]
  def change
    remove_column :snippets, :label_id
  end
end
