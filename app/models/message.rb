require 'elasticsearch/model'
class Message < ApplicationRecord
  belongs_to :chat
  
  include SearchableMessage
end
