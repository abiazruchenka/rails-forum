class TopicsController < ApplicationController

  before_action :authenticate_user!, only: [:create, :new]
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :set_section, only: [:new, :show, :edit]
  before_action :only_topic_fetch, only: [:create, :update]


  PAGINATION_LIMIT = 10.freeze

  # GET /topics
  # GET /topics.json
  def index; end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @message = Message.new()
    @like = Like.new()
    messages = @topic.messages
    messages = messages.where('text like ?', "%#{params[:text]}%") if params[:text]
    @messages = messages.order(created_at: :asc).paginate(page: params[:page], per_page: PAGINATION_LIMIT)
  end

  # GET /topics/new
  def new
    @topic = Topic.new()
    @message = Message.new()
  end

  # GET /topics/1/edit
  def edit; end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        @message = Message.new(message_params)
        unless @message.save
          format.html { render :new }
          format.json { render json: @topic.errors, status: :unprocessable_entity }
        end
        format.html { redirect_to chapter_topic_path(current_chapter, @topic), notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to chapter_topic_path(current_chapter, @topic), notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to chapter_path(current_chapter), notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      @topic_params.except(:message).merge(internal_topic_params).permit!
    end

    def internal_topic_params
      {chapter_id: current_chapter, user_id: current_user.id, status: Constant::STATUS }
    end

    def message_params
      external_message_params = @topic_params.fetch(:message, {})
      internal_message_params = {topic_id: @topic.id, chapter_id: current_chapter,
                                 user_id: current_user.id, status: Constant::STATUS, order: 1}
      external_message_params.merge(internal_message_params).permit!
    end

    def only_topic_fetch
      @topic_params = params.fetch(:topic, {})
    end

    def current_chapter
      params.fetch(:chapter_id, {})
    end

    def set_section
      @chapter = Chapter.find(params[:chapter_id])
    end
end
