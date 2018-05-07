module AdminsHelper
  def authenticate_admin
    # не должно быть редиректов в хелперах. Это логика Controller слоя, попавшая во View
    redirect_to '/', alert: 'Not authorized.' unless current_user.try(:admin) == 1
  end
end