#encoding: utf-8
class TaskMailer < ActionMailer::Base
  default from: "vypro@jchsoft.cz"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_mailer.new.subject
  #
  def new_task(task)
    @task = task

    mail to: task.assigned_user.email, subject: "Vypro prj.: #{task.project.name}, úkol: #{task.name}"
  end
end
