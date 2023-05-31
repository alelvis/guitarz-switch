class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      query = "
              SELECT o.* FROM orders o
              JOIN guitars g ON o.guitar_id = g.id
              WHERE o.user_id = :user_id
              OR g.user_id = :user_id
           "
      # scope.includes(:guitars).where(user: user).or
      scope.find_by_sql([query, { user_id: user.id }])
    end
  end

  def my_purchases?
    false
  end

  def my_sales?
    false
  end

  def show?
    true
  end

  def create?
    true
  end
end
