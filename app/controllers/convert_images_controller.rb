class ConvertImagesController < ApplicationController
    def new
        @convert_image = ConvertImage.new
    end

    def create
        @con = ConvertImage.create(convert_image_params.merge(user_id: current_user.id))
    end

    private

    def convert_image_params
    params.require(:convert_image).permit(:image)
    end
end