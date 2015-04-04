class ChangeTravelMilestoneFormatInTravels < ActiveRecord::Migration
  def change
  	change_column :travels, :travel_milestone, :text
  end
end
