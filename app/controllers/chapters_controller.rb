class ChaptersController < ApplicationController

  include AdminsHelper

  before_action :authenticate_admin, only:[:edit, :update, :destroy]
  before_action :set_chapter, only: [:show, :edit, :update, :destroy]

  PAGINATION_LIMIT = 10.freeze

  def show
    topics = @chapter.topics
    # ActiveRecord в не должен просачиваться на уровень контролеера. Для этого есть named scopes.
    # Кроме того весь этот код неплохо смотрелся бы в сервисе.
    topics = topics.where('title like ?', "%#{params[:name]}%") if params[:name]
    @topics = topics.order(created_at: :desc).paginate(page: params[:page], per_page: PAGINATION_LIMIT)
  end

  def new
    @chapter = Chapter.new
  end

  def edit
    @sections = Section.all
  end

  # POST /chapters
  # POST /chapters.json

  # Я не совсем понимая зачем здесь ответ на два формата (html и json). В коде я нашел только обращения по html.
  # Как API это не сойдет, потому что:
  # * Нужна живая сессия для запроса
  # * API должно лежать в своем контроллере на другом роуте с версионированием. /api/v1/chapters_controller.rb
  def create
    @chapter = Chapter.new(chapter_params)

    respond_to do |format|
      if @chapter.save
        format.html { redirect_to @chapter, notice: 'Chapter was successfully created.' }
        format.json { render :show, status: :created, location: @chapter }
      else
        format.html { render :new }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chapters/1
  # PATCH/PUT /chapters/1.json
  def update
    respond_to do |format|
      if @chapter.update(chapter_params)
        format.html { redirect_to @chapter, notice: 'Chapter was successfully updated.' }
        format.json { render :show, status: :ok, location: @chapter }
      else
        format.html { render :edit }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chapters/1
  # DELETE /chapters/1.json
  def destroy
    @chapter.destroy
    respond_to do |format|
      format.html { redirect_to sections_url, notice: 'Chapter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chapter_params
      first_chapter_params = params.fetch(:chapter, {})
      second_chapter_params = {user_id: current_user.id, status: Constant::STATUS }
      first_chapter_params.merge(second_chapter_params).permit!
    end

end
