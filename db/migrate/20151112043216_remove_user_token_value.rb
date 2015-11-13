class RemoveUserTokenValue < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.update_column(:token, "")
    end
  end
end
