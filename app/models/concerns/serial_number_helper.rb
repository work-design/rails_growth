module SerialNumberHelper

  def self.result(timestamp, repeat_type)
    year = timestamp.year
    case repeat_type
    when 'daily'
      number = timestamp.yday
    when 'weekly'
      number = timestamp.cweek
    when 'monthly'
      number = timestamp.month
    when 'yearly'
      year = timestamp.year
      number = ''
    when 'forever'
      year = timestamp.year
      number = timestamp.to_i
    else
      year = ''
      number = ''
    end

    [year, number].join('-')
  end

end
