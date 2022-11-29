module Api
  module V1
class ApplicationsController < ApiController
  before_action :set_application, only: %i[ show update destroy ]

  # GET /applications or /applications.json
  def index
    @applications = Application.all
    render json: @applications
  end

  # GET /applications/1 
  def show
    render json: @application
  end


  # POST /applications 
  def create
    uuid = SecureRandom.uuid
    exist = true

    while(exist)
      if Application.exists?(uuid)
        uuid = SecureRandom.uuid
      else
        exist = false
      end
    end  
        @application = Application.new(application_params)
        @application.id = uuid

        if @application.save
          render json: @application, status: :created
        else
          render json: @application.errors, status: :unprocessable_entity
        end
      end

  # PATCH/PUT /applications/1
  def update
    @application.lock!
    if @application.update(application_params)
      render json: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:name)
    end
end
end
end
