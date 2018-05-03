module AdminsHelper
  def authenticate_admin
    redirect_to '/', alert: 'Not authorized.' unless current_user.try(:admin) == 1
  end
end