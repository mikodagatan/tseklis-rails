module DeviseHelper
  def devise_error_messages!
    return if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg, class: "small-font-size") }.join
    sentence = I18n.t('errors.messages.not_saved',
      count: resource.errors.count,
      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="callout warning small-font-size">
      #{sentence}
      #{messages}
    </div>

    HTML

    html.html_safe
  end
end