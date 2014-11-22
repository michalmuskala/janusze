class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end

  class << self
    attr_writer :base_class

    def presents(name)
      define_method(name) do
        @object
      end
    end

    def base_class
      @base_class ||= self.name.demodulize.gsub('Presenter', '').constantize
    end

    def human_attribute_name(attribute)
      base_class.human_attribute_name(attribute)
    end
  end

  def h
    @template
  end

  def present_attributes(*attrs, &block)
    content = attrs.map do |attribute|
      name = self.class.human_attribute_name(attribute)
      h.content_tag(:dt, name) + h.content_tag(:dd, send(attribute))
    end
    content << h.capture(&block) if block_given?
    h.content_tag(:dl, content.join.html_safe, class: 'attributes')
  end
end
