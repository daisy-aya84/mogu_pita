class User < ApplicationRecord
  require 'base64'
  require 'json'
  require 'net/https'
  require 'rmagick'
  
  # 環境変数とAPI_URLを定数として定義します。
  # 環境変数から呼び出すように変更する
  API_KEY = ENV['GOOGLE_VISION_API_KEY']
  API_URL = "https://vision.googleapis.com/v1/images:annotate?key=#{API_KEY}"
  
  def triming
    user_id = self.id
    
    face_file = "public/images/#{self.image}" # ユーザーがとる顔写真
    crop_face_file = "cut#{user_id}.jpg" # くり抜いたユーザーの顔写真
    
    # ユーザーの顔写真をbase64形式に変換
    base64_face = Base64.strict_encode64(File.new(face_file).read)

    body = {
        requests: [{
          image: {
            content: base64_face
          },
          features: [
            {
              type: 'FACE_DETECTION', #画像認識の分析方法を選択
              maxResults: 10  # 出力したい結果の数
            }
          ]
        }]
    }.to_json
    
    # 文字列のAPI_URLをURIオブジェクトに変換します。
    uri = URI.parse(API_URL)   
    
    # httpではなく暗号化通信の施されたhttpsを用いる設定です。
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    
    # POSTリクエストを作成します
    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/json"
    
    # httpsでリクエストを送信します。
    response = https.request(request, body)
    
    # 返り値がJSON形式のため、JSONをrubyで扱えるように変換。
    response_rb = JSON.parse(response.body)
    
    ################
    # 認識した人数 #
    ################
    faceNumber = response_rb.to_s.scan("fdBoundingPoly").length
    puts "認識した人数:" + faceNumber.to_s
    
    i = 0
    
    while faceNumber > 0 do
        # ユーザーの顔写真の左上の座標を手に入れる
        description = response_rb["responses"][0]["faceAnnotations"][i]["fdBoundingPoly"]["vertices"][0]
        faceShitenX = description["x"]
        faceShitenY = description["y"]
        
        # ユーザーの顔写真の縦横のピクセルを手に入れる
        description = response_rb["responses"][0]["faceAnnotations"][i]["fdBoundingPoly"]["vertices"][2]
        faceNagasaX = description["x"] - faceShitenX
        faceNagasaY = description["y"] - faceShitenY

        # ユーザーの顔写真をトリミングする
        original = Magick::Image.read(face_file).first
        image = original.crop(faceShitenX, faceShitenY, faceNagasaX, faceNagasaY)
        
        #########################
        # ファイル名を変更する #
        #########################
        image.write("public/cut_pics/cut#{user_id}_#{i}.jpg")
        
        # "cut#{user_id}_#{i}.jpg"

        faceNumber -= 1
        i += 1
    end
    i + 1
  end
  
  def resize(food_id)
    @food = Food.find_by(id: food_id)
    crop_face_file = "public/cut_pics/#{self.cut_img}" # くり抜いたユーザーの顔写真

    foodNagasaX = @food.width # ご飯の写真の顔のxの長さ
    foodNagasaY = @food.height # ご飯の写真の顔のyの長さ

    # ユーザーの顔写真をリサイズする
    imageList = Magick::ImageList.new(crop_face_file)
    imageList = imageList.resize(foodNagasaX, foodNagasaY)
    imageList.write("public/re/re#{self.id}.jpg")
    "re#{self.id}.jpg"
  end
  
  def mix(food_id)
    @food = Food.find_by(id: food_id)

    crop_face_file = "public/re/#{self.resized_img}"        # リサイズしたユーザーの顔写真
    food_file = "public/foods/#{self.op_id}/#{@food.image}" # ご飯の写真

    foodShitenX = @food.x # ご飯の写真の顔の始点のx座標
    foodShitenY = @food.y # ご飯の写真の顔の始点のx座標

    # 画像を合成する
    imageListFrom = Magick::ImageList.new(food_file)
    imageListFrame = Magick::ImageList.new(crop_face_file)
    imageList = imageListFrom.composite(imageListFrame, foodShitenX, foodShitenY, Magick::OverCompositeOp)
    imageList.write("public/finals/final#{self.id}.jpg")
    "final#{self.id}.jpg"
  end
end
