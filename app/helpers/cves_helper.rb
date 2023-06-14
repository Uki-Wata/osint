module CvesHelper
    def score_color(score)
      case score
      when 0.0
        'none'
      when 0.1..3.9
        'low'
      when 4.0..6.9
        'medium'
      when 7.0..8.9
        'high'
      when 9.0..10.0
        'critical'
      else
        ''
      end
    end

end
