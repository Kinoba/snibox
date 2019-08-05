class RemoveLabelIdFromSnippet < ActiveRecord::Migration[5.2]
  def change
    Snippet.where.not(label_id: [nil, ""]).each do |snippet|
      label = Label.find_or_create_by(name: snippet.label.strip.upcase)
      labeling = label.labelings.build(snippet: snippet)
      labeling.save
    end
    remove_column :snippets, :label_id
  end
end
