module ConnectionsHelper
  def format_next_refresh_date(date)
    date.in_time_zone("EET").strftime("%Y/%m/%d, at %H:%M:%S")
  end
end