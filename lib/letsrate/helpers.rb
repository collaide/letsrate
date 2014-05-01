module Helpers
  def rating_for(rateable_obj, dimension=nil, options={})

    cached_average = rateable_obj.average dimension

    avg = cached_average ? cached_average.avg : 0

    star = options[:star] || 5
    path = options[:path]

    disable_after_rate = options[:disable_after_rate] || true

    readonly = !(current_user && rateable_obj.can_rate?(current_user, dimension))

    print_div_stars dimension, avg, rateable_obj.id, rateable_obj.class.name, disable_after_rate, readonly, star, path
  end

  def rating_for_user(rateable_obj, rating_user, dimension = nil, options = {})
    @object = rateable_obj
    @user = rating_user
	  @rating = Rate.find_by_rater_id_and_rateable_id_and_dimension(@user.id, @object.id, dimension)
	  stars = @rating ? @rating.stars : 0

    disable_after_rate = options[:disable_after_rate] || false
    path = options[:path]
    readonly=false
    if disable_after_rate
      readonly = current_user.present? ? !rateable_obj.can_rate?(current_user.id, dimension) : true
    end

    print_div_stars dimension, stars, rateable_obj.id, rateable_obj.class.name, disable_after_rate, readonly, stars, path
  end

end

class ActionView::Base
  include Helpers
end

private

def print_div_stars(dimension, rating, id, class_name, disable_after_rate, readonly, star_count, path)
  options = {"data-dimension" => dimension, :class => "star", "data-rating" => rating,
             "data-id" => id, "data-classname" => class_name,
             "data-disable-after-rate" => disable_after_rate,
             "data-readonly" => readonly,
             "data-star-count" => star_count}
  options['data-path'] = path if path

  content_tag :div, '', options
end