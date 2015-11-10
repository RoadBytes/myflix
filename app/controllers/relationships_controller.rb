class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.leader_relationships
  end

  def create
    leader = User.find_by(id: params[:leader_id])
    relationship = Relationship.new(leader: leader, follower_id: current_user.id)
    relationship.save unless relationship.leader == current_user
    redirect_to people_path
  end

  def destroy
    relationship = Relationship.where(id: params[:id]).first
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
end
