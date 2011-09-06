require 'rails_admin/abstract_model'

module RailsAdmin
  class ApplicationController < ::ApplicationController
    newrelic_ignore if defined?(NewRelic)

    before_filter :_authenticate!
    before_filter :_authorize!
    before_filter :set_plugin_name

    helper_method :_current_user

    def get_model
      model_name = to_model_name(params[:model_name])
      @abstract_model = RailsAdmin::AbstractModel.new(model_name)
      @model_config = RailsAdmin.config(@abstract_model)
      not_found if @model_config.excluded?
      @properties = @abstract_model.properties
    end

    def to_model_name(param)
      parts = param.split("~")
      parts[-1] = parts.last.singularize
      parts.map(&:camelize).join("::")
    end

    def get_object
      @object = @abstract_model.get(params[:id])
      assign_current_user_to_model
      not_found unless @object
    end
    
    def assign_current_user_to_model
      unless @object.nil? && RailsAdmin.config.model_current_user.nil?
        @object.send(RailsAdmin.config.model_current_user, _current_user) if (@object.respond_to?(RailsAdmin.config.model_current_user))
      end
    end
    private

    def _authenticate!
      instance_eval &RailsAdmin::Config.authenticate_with
    end

    def _authorize!
      instance_eval &RailsAdmin::Config.authorize_with
    end

    def _current_user
      instance_eval &RailsAdmin::Config.current_user_method
    end

    def set_plugin_name
      @plugin_name = "RailsAdmin"
    end

    def not_found
      render :file => Rails.root.join('public', '404.html'), :layout => false, :status => 404
    end

    def rails_admin_controller?
      true
    end
  end
end
