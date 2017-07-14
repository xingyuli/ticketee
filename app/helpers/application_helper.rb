module ApplicationHelper
  def admins_only
    yield if current_user.try(:admin?)
  end
  def authorized?(permission, thing)
    yield if can?(permission.to_sym, thing) || current_user.try(:admin?)
  end
end
