module SerialNumberHelper

  def self.result(timestamp, repeat_type)
    time = timestamp.to_datetime
    year = time.year
    month = time.month
    day = time.day
    cweek = time.cweek
    seconds = time.seconds_since_midnight

    case repeat_type
    when 'forever'
      [year, month, cweek, day, seconds, UidHelper.rand_string].join('-')
    when 'daily'
      [year, month, cweek, day].join('-')
    when 'weekly'
      [year, month, cweek].join('-')
    when 'monthly'
      [year, month].join('-')
    when 'yearly'
      year.to_s
    else
      ''
    end
  end

end
