module ApplicationHelper
   ALERT_CLASSES = { :notice => 'success', :alert => 'danger' }

  def alert_class(key)
    "alert-#{ALERT_CLASSES[key.to_sym]}"
  end
end
