class WelcomeController < ApplicationController
  def index
    (@filterrific = initialize_filterrific(
      Schedule,
      params[:filterrific],
      select_options: {
        by_departure: Schedule.options("departure"),
        by_destination: Schedule.options("destination"),
        by_date: Schedule.options("date"),
        by_time: Schedule.options("time"),
        sorted_by: Schedule.options_for_sorted_by
      },
    )) || return
    @schedule = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    if Current.user.nil? || Current.user.name != "ADMIN"
      redirect_to root_path
    else
      @schedule = Schedule.new
    end
  end

  def create
    @schedule = Schedule.new(sched_params)
    if @schedule.save
      flash[:success] = 'Schedule created'
      redirect_to root_path
    else
      flash[:danger] = @schedule.errors.full_messages.to_sentence
      redirect_to add_schedule_path
    end
  end

  def show
    if Current.user.nil? || Current.user.name != "ADMIN"
      redirect_to root_path
    else
      @bookings = Booking.where(schedule_id: params[:book_id])
    end
  end

  private

  def sched_params
    params.require(:schedule).permit(:departure, :destination, :date, :time, :seats_available, :price)
  end
end
