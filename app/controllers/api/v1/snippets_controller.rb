class Api::V1::SnippetsController < Api::BaseController
  include ResponseData

  before_action :set_snippet, except: :create
  before_action :set_snippet_file, only: [:raw]

  def create
    @snippet = Snippet.new(snippet_params.except(:label_attributes))
    completed = @snippet.save
    find_label(snippet_params)
    render json: entity_save_data(@snippet, completed)
  end

  def update
    completed = @snippet.update(snippet_params)
    render json: entity_save_data(@snippet, completed)
  end

  def destroy
    @snippet.destroy
    data = { completed: true }
    render json: data
  end

  def raw
    render plain: @snippet_file.content
  end

  private

  def set_snippet
    @snippet = Snippet.find(params[:id])
  end

  def set_snippet_file
    @snippet_file = @snippet.snippet_files.find_by(id: params[:snippet_file])
  end

  def find_label(data)
    labels = data[:label_attributes]['name'].split(',')
    return if labels.nil?
    labels.each { |label|
      @label = Label.find_or_create_by(name: label.strip.upcase)
      @labeling = @label.labelings.build(snippet: @snippet)
      @labeling.save
    }
  end

  def snippet_params
    # TODO: it's legacy for core counter_cache issues
    data = params.require(:snippet).permit(:title, :description, :id, snippet_files_attributes: [:id, :title, :content, :language, :tabs, :_destroy], label_attributes: [:name])
    return data
  end
end
