module EventsHelper
	def event_with_link_to_name(event)
		unless event.data_id.nil? or event.originator_name.nil?
			description = ''; description = event.data.description if event.data.respond_to?(:description) and !event.data.description.nil?
			link_to(event.originator_name, path_to_originator(event))+ (description.empty? ? '' : '&nbsp;"').html_safe + description[0..20] + (description.length>15 ? '...':'') + (description.empty? ? '' : '"')
		else
			event.data_id
		end
	end

	def path_to_originator(event)
		unless event.data_id.nil? or !event.data_exists?
			case event.target_class
				when 'projects'
					project_path(event.data_id)
				when 'companies'
					company_path(event.data_id)
				when 'tasks'
					task = event.data
					project_task_path(task.project_id, task.id)
				when 'efforts'
					effort = event.data
#					if effort.user_id == current_user.id
#						project_task_effort_path(effort.task.project_id, effort.task_id, effort.id)
#					end
						project_task_path(effort.task.project_id, effort.task_id)
				when 'notes'
					note = event.data
					project_task_note_path(note.task.project_id, note.task_id, note.id)
				when 'annexes'
					annex = event.data
					project_task_annex_path(annex.task.project_id, annex.task_id, annex.id)
			end
		end
	end

	def originator_t_name(event)
		eval(event.target_class.singularize.capitalize).find(event.data_id).name
	end
end
