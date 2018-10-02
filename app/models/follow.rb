# == Schema Information
#
# Table name: follows
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  board_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Follow < ApplicationRecord
  belongs_to :user
  belongs_to :board
  validates :user_id, uniqueness: { scope: :board_id }
end
