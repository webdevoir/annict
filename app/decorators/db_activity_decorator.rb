# frozen_string_literal: true

class DbActivityDecorator < ApplicationDecorator
  def resource_diff_table
    return if action_table_name == "comments"
    model = trackable.class
    old_params = parameters["old"].presence || {}

    new_resource = model.new(parameters["new"].slice(*model.column_names))
    old_resource = model.new(old_params.slice(*model.column_names))
    origin_values = if old_params.present?
      old_resource.decorate.to_values
    else
      {}
    end

    data = {
      resource: trackable,
      diffs: diffs(new_resource, old_resource),
      draft_values: new_resource.decorate.to_values,
      origin_values: origin_values
    }

    h.render("db/activities/resource_diff_table", data)
  end
end
