module ApplicationHelper
    def get_twitter_card_info(user)
        p "================"
        p user
        p "================"
        twitter_card = {}
        if user
            p "================"
            p "きてるよ"
            p "================"
        
            twitter_card[:url] = "https://summer-third-seminer-ayanooooon.c9users.io/users/#{user.id}/share"
            twitter_card[:title] = "#{user.name}がたくさん食べたよ"
            twitter_card[:description] = "#{user.name}さんの、おいしいものを食べた気分になれる画像を見てみましょう"
            twitter_card[:image] = "https://summer-third-seminer-ayanooooon.c9users.io/finals/final#{user.id}.jpg"
            p "================"
            p   twitter_card[:url]
            p   twitter_card[:title]
            p   twitter_card[:description]
            p   twitter_card[:image]
            p "================"
        else
            twitter_card[:url] = 'https://summer-third-seminer-ayanooooon.c9users.io/'
            twitter_card[:title] ='かおピタ｜顔をあてはめてご飯の気分'
            twitter_card[:description] = 'おいしいご飯をたくさん食べたきもちになれる、新感覚サービス'
            twitter_card[:image] = 'https://summer-third-seminer-ayanooooon.c9users.io/eyecatch.png'
        end
        twitter_card[:card] = 'summary_large_image'
        twitter_card[:site] = '@teru_aya84'
        twitter_card
    end 
end