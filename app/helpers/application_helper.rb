module ApplicationHelper
   ALERT_CLASSES = { :notice => 'success', :alert => 'danger' }

  def alert_class(key)
    "alert-#{ALERT_CLASSES[key.to_sym]}"
  end

  def stars_for_rating(rating, **kwargs, &url_block)
    wholes  = rating.to_i
    halfs   = (rating - wholes >= 0.5) ? 1 : 0
    empties = 6 - wholes - halfs

    render :partial => 'layouts/stars', :locals => { :wholes     => wholes,
                                                     :halfs      => halfs,
                                                     :empties    => empties,
                                                     :url_block  => url_block,
                                                     :url_kwargs => kwargs}
  end

  def search_url(with:{}, without:{}, set:{}, unset:{})
    options = current_search_options_with_serialised_values(:with => with, :without => without, :set => set, :unset => unset)
    projects_path(options)
  end

  def current_search_options_with_serialised_values(with:{}, without:{}, set:{}, unset:{})
    options = current_search_options.deep_dup

    # remove without
      options.merge!(without) { |key, old_val, new_val| remove_values(key, old_val, new_val) }
    # add with
      options.merge!(with) { |key, old_val, new_val| merge_values(key, old_val, new_val) }
    # unset
      unset.each { |key| options.delete(key) }
    # set
      set.each { |key, value| options[key] = value }

    options = Hash[options.map do |key, value| [key, value]
      new_value = if value.is_a?(Array)
        value.join(',')
      else
        value
      end

      [key.to_s.dasherize.to_sym, new_value] if new_value.present?
    end.filter(&:present?)]
  end

  def term_facet_to_hash(facet_hash)
    Hashie::Mash.new(Hash[facet_hash.terms.map { |facet| [facet['term'], facet['count']] }])
  end

  protected
    def merge_values(key, old_val, new_val)
      Array.wrap(old_val).concat(Array.wrap(new_val)).uniq
    end

    def remove_values(key, old_val, new_val)
      (Array.wrap(old_val) - Array.wrap(new_val)).uniq
    end
end
