class UsersController < ApplicationController

  include AdminsHelper

  before_action :authenticate_user!
  before_action :authenticate_admin, only:[:edit, :update, :destroy, :new, :create_user]
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  PAGINATION_LIMIT = 10.freeze
  MESSAGE_PAGINATION_LIMIT = 3.freeze

  def index
    @users = User.order(user_name: :asc).paginate(page: params[:page], per_page: PAGINATION_LIMIT)
  end

  def show
    @chapters = Chapter.all
    @chapter = params[:chapter_id]
    # Опять
    topics = Topic.joins(:messages).where(messages:{user_id: @user.id}).distinct
    topics = topics.where(chapter_id: params[:chapter_id]) if @chapter && @chapter.present?
    @topics = topics.order(updated_at: :desc).paginate(page: params[:page], per_page: MESSAGE_PAGINATION_LIMIT)
  end

  def new
    @user = User.new
  end

  def create_user
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_path(@user.id), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user.toggle :admin if can? :manage, @user
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to user_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.fetch(:user, {}).permit!
  end

end
