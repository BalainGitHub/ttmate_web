class User < ActiveRecord::Base
	has_many :devices
	has_many :alarms
	accepts_nested_attributes_for :devices
end
