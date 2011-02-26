class ApplicationController < ActionController::Base
  protect_from_forgery

  def send_action(sym)
    params = extract_params_for(method(sym))
    super(sym, *params)
  end

  private
  def extract_params_for(method)
    types = method.parameters
    if has_parameters(types)
      provide_instances_for(types)
    else
      []
    end
  end
  
  def has_parameters(types)
    types.size!=0 && types[0]!=[:rest]
  end
  
  def provide_instances_for(params)
    params.collect do |param|
      provide(param[1])
    end
  end
  
  class Load
    def play(controller, params, name)
      var = type_for(name)
      loaded = var.camelize.constantize.find(params[:id])
      controller.send :instance_variable_set ,"@#{var}", loaded
      return loaded
    end
    def type_for(name)
      name[7..-1]
    end
    def can_handle?(name)
      name[0..6]=="loaded_" && defined?(type_for(name).camelize.constantize)
    end
  end
  class Instantiate
    def play(controller, params, var)
      val = Product.new(params[p])
      controller.send :instance_variable_set ,"@#{var}", val
      return val
    end
    def can_handle?(name)
      defined?(name.camelize.constantize)
    end
  end
  class NilLocator
    def play(controller,params,var)
    end
    def can_handle?(name)
      true
    end
  end

  def provide(p)
    var = p.to_s
    provider = [Load.new, Instantiate.new, NilLocator.new].find do |f|
      f.can_handle?(var)
    end
    provider.play(self, params, var)
  end
end
