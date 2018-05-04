class MessagesController < ApplicationController

  before_action :authenticate_user!, only: [:create, :new, :update, :destroy, :edit]
  before_action :only_message_fetch, only: [:create, :update]
  before_action :update_text, only: [:update]
  before_action :set_message, only: [:edit, :update, :destroy]

  PAGINATION_LIMIT = 10.freeze

  def index
    @chapters = Chapter.all
    @chapter = params[:chapter_id]
    topics = Topic.where(user_id: params[:id]).all
    topics = topics.where(chapter_id: params[:chapter_id]) if @chapter && @chapter.present?
    @topics = topics.order(updated_at: :desc).paginate(page: params[:page], per_page: PAGINATION_LIMIT)
  end

  def show
    @message = Message.new()
  end

  def new
    @topic = Topic.new()
    @message = Message.new()
  end

  def edit
    @chapter = Chapter.find(@message.chapter_id)
    set_topic
  end

  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        set_topic.try(:touch)
        format.html { redirect_to chapter_topic_path(@message.chapter_id, @message.topic_id), notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to chapter_topic_path(@message.chapter_id, @message.topic_id),
                                  notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message.destroy

    respond_to do |format|
      format.html { redirect_to chapter_topic_path(current_chapter, @topic), notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def message_params
    @message_params.merge({user_id: current_user.id, status: @status, order: 1}).permit!
  end

  def only_message_fetch
    @status = Constant::STATUS
    @message_params = params.fetch(:message, {})
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def update_text
    @status = "updated by #{current_user.user_name} at"
  end

  def set_topic
    @topic = Topic.find(@message.topic_id)
  end

end
