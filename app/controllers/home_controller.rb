class HomeController < ApplicationController

    def index
        if signed_in?
            redirect_to new_convert_image_path
        end
    end

end