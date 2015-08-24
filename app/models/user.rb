class User < ActiveRecord::Base
	has_many :devices
	has_many :travels
	has_one :app_setting

	accepts_nested_attributes_for :devices, :app_setting
end
