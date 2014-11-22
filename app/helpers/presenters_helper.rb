module PresentersHelper
  def present(object_or_collection, klass = nil)
    if object_or_collection.respond_to?(:empty?) && object_or_collection.empty?
      return object_or_collection
    end
    klass ||= guess_klass(object_or_collection)
    presenter_or_presenters = convert_to_presenter(object_or_collection, klass)
    yield presenter_or_presenters if block_given?
    presenter_or_presenters
  end

  private

  def guess_klass(object_or_collection)
    object = if object_or_collection.respond_to?(:map)
               object_or_collection.first
             else
               object_or_collection
             end
    "#{object.class}Presenter".constantize
  end

  def convert_to_presenter(object_or_collection, klass)
    if object_or_collection.respond_to?(:map)
      object_or_collection.map { |element| klass.new(element, self) }
    else
       klass.new(object_or_collection, self)
     end
  end
end
