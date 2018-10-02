# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  board_id   :integer
#  user_id    :integer
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Comment, type: :model do

end
