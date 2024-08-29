# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protected

  def layout_by_resource
    if user_signed_in?
      'login_common'
    else
      'application'
    end
  end
end
