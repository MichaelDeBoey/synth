class Api::ExchangesController < ApiController
  def index
    # Issue: N+1 Query
    # Resolution: Use `includes` to eagerly load associated data
    exchanges = Exchange.includes(:association_name).order(:name)

    # Issue: Hardcoded value
    # Resolution: Make the items per page configurable or use a constant
    @pagy, @exchanges = pagy(exchanges, items: 2)

    # Issue: Unused argument
    # Resolution: Remove unused argument or replace it with a more descriptive value
    api_user.charge_credits(1, "Exchange index")
  end

  def show
    # Issue: Redundant condition
    # Resolution: Rails automatically handles RecordNotFound, no need to raise it manually
    @exchange = Exchange.find_by("lower(acronym) = ? OR lower(mic_code) = ?", params[:id].downcase, params[:id].downcase)

    # Issue: Unused argument
    # Resolution: Remove unused argument or replace it with a more descriptive value
    api_user.charge_credits(1, @exchange)
  end
end
