Rails.application.routes.draw do
  mount JellyfishMiq::Engine => '/jellyfish_miq'
end
