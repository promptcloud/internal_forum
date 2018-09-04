# frozen_string_literal: true

module Users
  class RegistrationsController < ::Devise::RegistrationsController
    invisible_captcha only: %i[create], honeypot: :name

    def new
      redirect_to new_user_session_path
    end

    def update
      if params[:user][:display_name].present? 
        current_user.update(display_name: params[:user][:display_name]) 
        flash[:success] = "Your account has been updated successfully." 
        redirect_to user_path(current_user.id)
      else
        flash[:error] = current_user.errors.full_messages.join(', ')
        redirect_to edit_user_registration_path
      end
    end
  end
end
