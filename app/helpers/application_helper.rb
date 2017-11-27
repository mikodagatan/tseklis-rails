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
  end

  def better_date(date)
    date.strftime("%B %d, %Y") if date.present?
  end

  def better_date2(date)
    date.strftime("%B %d, %Y - %A") if date.present?
  end

  def default_date(date)
    date.strftime("%Y-%m-%d") if date.present?
  end

  def better_time(time)
    time.strftime("%I:%M%p")
  end

  def better_datetime(datetime)
    datetime.strftime('%b %d, %Y - %I:%M%p')
  end

  def nan_to_0(number)
    number.nan? ? 0 : number
  end

  def this_month
    Time.zone.today.strftime("%B")
  end

  def zero_to_non(number)
    number == 0 ? "" : number
  end


  def code_block( title = nil, lang = nil, &block )
    output = capture( &block ) # this is the answer to all your problems
    output = output.unindent   # optional, escape it as you want, too
    # rendering a partial is still possible,
    # but i'd recommend using an absolute path :
    render partial: 'my_html_bits/code_block',
           locals:  {title: title, lang: lang, text: output }
  end

end
