require 'spec_helper'

module FunctionalLightService
  module Procify
    def py(m, *args)
      args.count > 0 ? method(m).to_proc.curry[*args] : method(m)
    end
  end
end

class BookingController
  include FunctionalLightService::Prelude::Result
  include FunctionalLightService::Procify

  Context = Struct.new(:booking, :ability, :format)

  def index(id, format = :html)
    get_booking(id) << log(:booking) >>
      py(:ability)              << log(:ability) >>
      py(:present, format)      << log(:presenter) >>
      py(:render)               << log(:render)
  end

  def log(step)
    ->(data) { [step, data] }
  end

  def ability(ctx)
    ctx.ability = {} # Ability.new(@booking)
    Success(ctx)
  end

  def present(format, ctx)
    ctx.format = format

    Success(ctx)
  end

  def render(ctx)
    send(ctx.format, ctx)
  end

  def html(ctx)
    Success(ctx)
  end

  def get_booking(id)
    ctx = Context.new
    ctx.booking = { :ref_anixe => id }
    Success(ctx)
    # @booking = @bms.booking_by_id(id)
    # rescue BSON::InvalidObjectId => ex
    # @booking = nil
    # @ui.error(404, ex.message)
  end
end

describe BookingController do
  it "does something" do
    bc = BookingController.new
    bc.index('1234', :html)
  end
end
