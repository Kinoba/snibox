require 'rails_helper'

describe 'Snippets', js: true do
  before do
    login
    sleep 0.5
  end

  context 'create' do
    it 'untagged snippet' do
      create_snippet('test snippet')
      within('#labels') { expect(page).to have_content('No labels found') }
      within('#snippets') { expect(page).to have_content('test snippet') }
    end

    it 'tagged snippet' do
      create_snippet('test snippet', 'test label')
      within('#labels') do
        expect(page).to have_content('test label')
        expect(page).to have_content('untagged')
      end
      within('#snippets') { expect(page).to have_content('test snippet') }
    end
  end

  context 'show' do
    before do
      create_snippet('test snippet', 'test label')
    end

    it 'user able to view raw' do
      expect(page).to have_content('Raw')
    end

    it 'user able to delete' do
      find('#snippet-delete').click
      find('.swal2-confirm').click
      sleep 2
      within('#snippets') { expect(page).to have_no_content('test snippet') }
    end

    it 'user able to cancel delete' do
      find('#snippet-delete').click
      find('.swal2-cancel').click
      within('#snippets') { expect(page).to have_content('test snippet') }
    end

    it 'user able to edit snippet' do
      find('#snippet-edit').click
      sleep 1
      fill_in 'description', with: 'edited snippet'
      fill_in 'snippet-labels', with: 'edited label', fill_options: { clear: :backspace }
      click_on 'Update'

      within('#labels') do
        expect(page).to have_content('edited label')
        expect(page).to have_content('untagged')
      end
      within('#snippets') { expect(page).to have_content('edited snippet') }
    end
  end

  private

  def create_snippet(description, label = nil)
    click_on 'Add snippet'
    fill_in 'description', with: description
    fill_in_snippet_file_title(0, 'my snippet title')
    fill_in_editor_field(0)
    fill_in 'snippet-labels', with: label unless label.nil?
    click_on 'Create'
  end

  def fill_in_editor_field(index)
    within "#snippet-file-form-#{index} .CodeMirror" do
      current_scope.click
      field = current_scope.find('textarea', visible: false)
      field.send_keys 'Test snippet file content'
    end
  end

  def fill_in_snippet_file_title(index, title)
    fill_in "title-#{index}", with: title
  end
end
