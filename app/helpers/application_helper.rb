module ApplicationHelper
    def get_twitter_card_info(user)
        twitter_card = {}
        if user
            twitter_card[:url] = "https://summer-third-seminer-ayanooooon.c9users.io/users/#{user.id}/share"
            twitter_card[:title] = "#{user.name}が、じぶんでえがいた世界にはいりこんじゃった！"
            twitter_card[:description] = "#{user.name}のモグピタ画像をみてみましょう"
            twitter_card[:image] = "https://summer-third-seminer-ayanooooon.c9users.io/finals/final#{user.id}.jpg"
            p "=======twitter_card========="
            p  twitter_card[:url]
            p  twitter_card[:title]
            p  twitter_card[:description]
            p  twitter_card[:image]
            p "============================"
        else
            twitter_card[:url] = 'https://summer-third-seminer-ayanooooon.c9users.io/'
            twitter_card[:title] ='モグピタ｜じぶんで描いたイラストの世界にはいろう'
            twitter_card[:description] = 'きみはどんなじぶんになりたい？'
            twitter_card[:image] = 'https://summer-third-seminer-ayanooooon.c9users.io/eyecatch.png'
        end
        twitter_card[:card] = 'summary_large_image'
        twitter_card[:site] = '@teru_aya84'
        twitter_card
    end 
end