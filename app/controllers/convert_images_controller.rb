class ConvertImagesController < ApplicationController
    def new
        @convert_image = ConvertImage.new
    end

    def create
        image = ConvertImage.create(convert_image_params.merge(user_id: current_user.id))
        path = ActiveStorage::Blob.service.path_for(image.image.key)
        photo = Base64.encode64(File.read(path))
        
        image.update(image_binary: photo)
        @result = HTTParty.post( "https://textualapi.herokuapp.com/translates" , :body => { :image => photo}.to_json, :headers => { 'Content-Type' => 'application/json' } )

        puts "resultado del texto #{@result["message"]}"

        image.update(text_result: @result["message"])


        flash[:notice] = "texto de imagen =>  #{@result['message']}"
        redirect_to new_convert_image_path
    end

    private

    def convert_image_params
        params.required(:convert_image).permit(:image)
    end
end