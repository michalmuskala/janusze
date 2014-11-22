module ApplicationHelper
   ALERT_CLASSES = { :notice => 'success', :alert => 'danger' }

  def alert_class(key)
    "alert-#{ALERT_CLASSES[key.to_sym]}"
  end

  def stars_for_rating(rating)
    wholes  = rating.to_i
    halfs   = (rating - wholes >= 0.5) ? 1 : 0
    empties = 6 - wholes - halfs

    render :partial => 'layouts/stars', :locals => { :wholes  => wholes,
                                                     :halfs   => halfs,
                                                     :empties => empties }
  end
end
