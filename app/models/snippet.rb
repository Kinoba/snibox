class Snippet < ApplicationRecord
  belongs_to :label, optional: true
  has_many :snippet_files
  
  counter_culture :label

  accepts_nested_attributes_for :label
  accepts_nested_attributes_for :snippet_files

  validates :title, presence: true, length: { maximum: 40 }
  validates :content, presence: true, length: { maximum: 20000 }
  validates :language, presence: true, inclusion: { in: Editor.languages.keys.map(&:to_s) }
  validates :tabs, numericality: { only_integer: true }, inclusion: { in: [2, 4, 8] }

  after_commit :remove_unused_labels

  private

  def remove_unused_labels
    Label.where('snippets_count < 1').destroy_all
  end
end
