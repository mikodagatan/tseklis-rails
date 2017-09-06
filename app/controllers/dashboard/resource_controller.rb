class Dashboard::ResourceController < Dashboard::ApplicationController
  inherit_resources
  respond_to :html

  has_scope :page, default: 1
  self.responder = Dashboard::Responder
end
