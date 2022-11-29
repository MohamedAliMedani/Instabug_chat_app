module Api
  module V1
class MessagesController < ApiController
  before_action :set_message, only: %i[ show update destroy ]

  # GET /messages 
  def index
    query = params["query"] || ""
    @messages = Message.search(query, params[:chat_id])

    render json: @messages
  end

  # POST /messages 
  def create
    @message = Message.new(message_params)

    last_message = Message.where(chat_id: params[:chat_id]).last
    sequence_id = last_message ? last_message.message_number + 1 : 1
    @message.write_attribute(:message_number, sequence_id)

    if @message.save
      IncreaseCountOfMessagesJob.perform_async(@message.chat_id)
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1 
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:message_number, :body, :is_deleted, :chat_id)
    end
end
end
end