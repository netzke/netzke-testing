Rails.application.routes.draw do
  if Rails.env.test? || Rails.env.development?
    get 'netzke/components/:class' => 'netzke/testing#components', as: :netzke_components
    get 'netzke/specs/*name' => 'netzke/testing#specs', as: :netzke_specs
  end
end
