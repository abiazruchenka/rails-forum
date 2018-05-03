class AdminsController < ApplicationController

  include AdminsHelper

  before_action :authenticate_admin

  def index
    @chapter = Chapter.new
    @section = Section.new
    @sections = Section.all
  end

end