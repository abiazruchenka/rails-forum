module ApplicationHelper

  def user_admin?
    current_user.try(:admin) == 1
  end
end
