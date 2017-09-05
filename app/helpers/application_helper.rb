module ApplicationHelper

  def show_error_message(resource)
    return if resource.errors.empty?

    messages = resource.errors.full_messages.map { |a|
    	content_tag(:li, a, class: 'small-font-size')
    }.join

    html = <<-HTML
    <div class="callout failure small-font-size">
    	Prohibited this #{resource.class.name.humanize} from being saved:
    	<ul>
    	#{ messages }
    	</ul>
		</div>

    HTML

		html.html_safe
  end

  def no_flash_pages
    current_page?(root_path) ||
    current_page?(new_user_session_path) ||
    current_page?(user_session_path)
  end

  def better_date(date)
    date.strftime("%B %d, %Y") if date.present?
  end

end
