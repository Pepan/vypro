module ApplicationHelper
	def basetitle
		t("page.title.main")
	end

	def action_title
		t('page.title.'+controller.controller_name+'.'+controller.action_name)
	end
	
	# Return a title on a per-page basis.
	def title
		if @title.nil?
			"#{action_title} | #{basetitle}"
		else
			"#{action_title} | #{@title} | #{basetitle}"
		end
	end
	
	def description
		if @description.nil?
			t('page.desc.'+controller.controller_name+'.'+controller.action_name)
		else
			@description
		end
	end

end
