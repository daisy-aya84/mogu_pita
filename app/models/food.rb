class Food < ApplicationRecord
  require 'base64'
  require 'json'
  require 'net/https'
  require 'RMagick'
  
  # 環境変数とAPI_URLを定数として定義します。
  # 環境変数から呼び出すようにする
  API_KEY = ENV['GOOGLE_VISION_API_KEY']
  API_URL = "https://vision.googleapis.com/v1/images:annotate?key=#{API_KEY}"

  def get_positions
    face_file = "public/foods/#{self.op_id}/#{self.image}" # ユーザーがとる顔写真

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
            maxResults:  1  # 出力したい結果の数
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

    description = response_rb["responses"][0]["faceAnnotations"][0]["fdBoundingPoly"]["vertices"][0]
    # faceNumber -= 1
    faceShitenX = description["x"]
    faceShitenY = description["y"]
    # ユーザーの顔写真の縦横のピクセルを手に入れる
    description = response_rb["responses"][0]["faceAnnotations"][0]["fdBoundingPoly"]["vertices"][2]
    faceNagasaX = description["x"] - faceShitenX
    faceNagasaY = description["y"] - faceShitenY
    
    [faceShitenX, faceShitenY, faceNagasaX, faceNagasaY]
  end
  
  def small
    crop_face_file = "public/foods/#{self.op_id}/#{self.image}"
    imageList = Magick::ImageList.new(crop_face_file)

    imageList = imageList.resize(800, 550)
    imageList.write("public/foods/#{self.op_id}/#{self.id}.jpg")
    "#{self.id}.jpg"
  end
end
