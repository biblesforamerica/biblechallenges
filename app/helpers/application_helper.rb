module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-danger"
      when :alert
        "alert-warning"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def avatar_url(user, size)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def select_options_for_bible
    [["ASV (American Standard)",'ASV'],["ESV (English Standard)",'ESV'],["KJV (King James)",'KJV'],["NASB (New American Standard)",'NASB'],["NKJV (New King James)",'NKJV']]
  end

  def completion_ratio(membership)
    "#{membership.membership_readings.read.count}/#{membership.membership_readings.count}"
  end

  def completion_graph(membership)
    membership.membership_readings.map {|m| m.read? ? 'x' : '-' }.join
  end

end
