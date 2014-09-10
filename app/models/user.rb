class User < ActiveRecord::Base
	has_many :devices, :dependent => :destroy
	accepts_nested_attributes_for :devices, :allow_destroy => true
end
