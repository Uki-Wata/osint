Rails.application.routes.draw do
  get 'investigation/index'
  get 'investigation/show'
  get 'cves/index'
  root to: 'cves#index'
end
