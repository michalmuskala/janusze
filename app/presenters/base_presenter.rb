require_dependency 'html_with_pants'

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

    def markdown_render(text)
      @markdown_mutex ||= Mutex.new
      @markdown_renderer ||= Redcarpet::Markdown.new(HTMLWithPants.new)
      @markdown_mutex.synchronize do
        @markdown_renderer.render(text).html_safe
      end
    end
  end

  def present_attributes(*attrs, &block)
    content = attrs.map do |attribute|
      name = self.class.human_attribute_name(attribute)
      h.content_tag(:dt, name) + h.content_tag(:dd, send(attribute))
    end
    content << h.capture(&block) if block_given?
    h.content_tag(:dl, content.join.html_safe, class: 'attributes')
  end

  private

  def h
    @template
  end
end
