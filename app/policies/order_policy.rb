class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.includes(:guitars).where(user: user)
    end
  end
end
