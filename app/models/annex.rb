class Annex < ActiveRecord::Base
	belongs_to :task
	belongs_to :user

	mount_uploader :source, AnnexUploader

	attr_accessible :source, :task_id
	validate :name, :source, :ext, :size, :task_id, :user_id, presence: true

	before_validation(:on => :create) do
		unless self.source.nil?
			self.name = source.file.original_filename
			self.ext = File.extname(source.url)
			self.size = source.file.size
		end
	end

	private
end
