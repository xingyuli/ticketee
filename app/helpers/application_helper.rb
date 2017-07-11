module ApplicationHelper
  def admins_only
    yield if current_user.try(:admin?)
  end
end
