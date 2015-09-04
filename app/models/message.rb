class Message < ActiveRecord::Base
	before_save :add_sent_time
	belongs_to :sender,class_name: "User",foreign_key: "sender_id"
	belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"

	private
	def add_sent_time
		self.sent_at=Time.current
	end
end
