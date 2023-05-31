class GuitarPolicy < ApplicationPolicy
  class Scope < Scope

    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def destroy?
    record.user == user
  end

  def show?
    true
  end

  def edit?
    record.user == user
  end

  def update?
    record.user == user
  end

  def my_guitars?
    true
  end

  def create?
    true
  end

end
