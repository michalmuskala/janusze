module CocoonHelper
  def link_to_remove_association(*args, &block)
    if block_given?
      f            = args.first
      html_options = args.second || {}
      name         = capture(&block)
      link_to_remove_association(name, f, html_options)
    else
      name         = args[0]
      f            = args[1]
      html_options = args[2] || {}

      model = retrieve_model(f)
      is_dynamic = model.new_record?

      classes = []
      classes << "remove_fields"
      classes << (is_dynamic ? 'dynamic' : 'existing')
      classes << 'destroyed' if model.marked_for_destruction?
      html_options[:class] = [html_options[:class], classes.join(' ')].compact.join(' ')

      wrapper_class = html_options.delete(:wrapper_class)
      html_options[:'data-wrapper-class'] = wrapper_class if wrapper_class.present?

      hidden_field_tag("#{f.object_name}[_destroy]", model._destroy) + link_to(name, '#', html_options)
    end
  end

  def create_object(f, association, force_non_association_create=false)
    model = retrieve_model(f)
    assoc = model.class.reflect_on_association(association)

    assoc ? create_object_on_association(f, association, assoc, force_non_association_create) : create_object_on_non_association(f, association)
  end

  def create_object_on_non_association(f, association)
    model = retrieve_model(f)
    builder_method = %W{build_#{association} build_#{association.to_s.singularize}}.select { |m| model.respond_to?(m) }.first
    return f.object.send(builder_method) if builder_method
    raise "Association #{association} doesn't exist on #{f.object.class}"
  end

  def create_object_on_association(f, association, instance, force_non_association_create)
    model = retrieve_model(f)
    if instance.class.name == "Mongoid::Relations::Metadata" || force_non_association_create
      create_object_with_conditions(instance)
    else
      assoc_obj = nil

      # assume ActiveRecord or compatible
      if instance.collection?
        assoc_obj = model.send(association).build
        f.object.send(association).delete(assoc_obj)
      else
        assoc_obj = model.send("build_#{association}")
        f.object.send(association).delete
      end

      assoc_obj = assoc_obj.dup if assoc_obj.frozen?

      assoc_obj
    end
  end

  private

  def retrieve_model(f)
    f.object.respond_to?(:model) ? f.object.model : f.object
  end
end
