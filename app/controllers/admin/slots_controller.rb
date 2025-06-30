# app/controllers/admin/slots_controller.rb
class Admin::SlotsController < Admin::BaseController
  def index
    @slots = Slot.all
  end
end
