class NotificationServices::MagicService < NotificationService
  Label = 'magic'
  Fields = [
    [:api_token, {
      :placeholder => 'URL to receive a POST request when an error occurs',
      :label => 'URL'
    }]
  ]

  def check_params
    if Fields.detect {|f| self[f[0]].blank? }
      errors.add :base, 'You must specify the URL'
    end
  end

  def create_notification(problem)
    (api_token || '').split(' ').each do |hook|
      type, url = hook.split('|')
      case type
      when 'Webhook'
        HTTParty.post(url, :body => {:problem => problem.to_json})
      when 'Flowdock'
        NotificationServices::FlowdockService.new(api_token: url).create_notification(problem)
      end
    end
  end
end
