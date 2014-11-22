module Tags
  def self.all_tags_for(what, options={})
    what = { :projects => 'tags' }[what.to_sym] # to make it look more sensible from outside TODO figure
    starting_with = options[:starting_with]

    if what then
      tags = ActsAsTaggableOn::Tag.joins(:taggings).where('"taggings"."context" = ?', what).select('distinct tags.*')
      tags = tags.where('"tags"."name" LIKE ?', starting_with + '%') if starting_with

      tags.map do |tag|
        { :text => tag.name, :id => tag.name, :count => 1337 }
      end
    else
      []
    end
  end
end