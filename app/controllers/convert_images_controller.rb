class ConvertImagesController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @images = ConvertImage.where(user_id: current_user.id).order('created_at desc')
    end

    def new
        @convert_image = ConvertImage.new
        image_id = params[:image_id].to_i unless params[:image_id].nil?
        @convertI= ConvertImage.find(image_id) unless image_id==0 || image_id.nil?
        @message = @convertI.text_result unless @convertI.nil?
        puts @message
        if @convertI.present?
            @message = @convertI.text_result
            puts @message
            puts "*" *100
        end
    end

    def create
        @image = ConvertImage.create(convert_image_params.merge(user_id: current_user.id))
        path = ActiveStorage::Blob.service.path_for(@image.image.key)
        photo = Base64.encode64(File.read(path))
        
        @image.update(image_binary: photo)
        @result = HTTParty.post( "http://192.168.0.104:3000/translates" , :body => { :image => photo}.to_json, :headers => { 'Content-Type' => 'application/json' } )

        #puts "resultado del texto #{@result["message"]}"
        @message = @result["message"]
        @image.update(text_result: @result["message"])

        if @message == "" || @message ==  " \n\f"
            redirect_to new_convert_image_path
        else
        #flash[:notice] = "texto de imagen =>  #{@result['message']}"
        redirect_to new_convert_image_path(image_id: @image.id)
        end
    end

    private

    def convert_image_params
        params.required(:convert_image).permit(:image)
    end
end