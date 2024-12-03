# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

admin = User.new(
  email: 'zumiairhc@gmail.com',
  password: ENV['CONFIRMED_USER_PASS'],
  uid: SecureRandom.uuid
)
admin.skip_confirmation!
admin.save!

Profile.create(
  name: 'admin',
  birth_date: '1992-02-11',
  phone_number: '090-1111-2222',
  avatar: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/cat.jpg')),
                                                 filename: '小松寺の猫'),
  header: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/autumn.jpg')),
                                                 filename: '秋の写真'),
  self_introduction: '私が管理人です。このサイトで一番偉いです。敬い給へ。',
  user_id: admin.id
)

coron = User.new(
  email: 'coron@example.com',
  password: 'coron_dog',
  uid: SecureRandom.uuid
)
coron.skip_confirmation!
coron.save!

Profile.create(
  name: 'coron',
  birth_date: '2005-12-12',
  phone_number: '090-1234-5678',
  avatar: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/dog.jpg')),
                                                 filename: '実家のトイプー'),
  header: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/lasvegas.jpg')),
                                                 filename: 'ラスベガスの写真'),
  self_introduction: '元々は未熟児だったけど、成犬になったらトイプーの平均体重の倍まで大きくなりました。',
  user_id: coron.id
)

mii = User.new(
  email: 'mii@example.com',
  password: 'mii_cat',
  uid: SecureRandom.uuid
)
mii.skip_confirmation!
mii.save!

Profile.create(
  name: 'mii',
  birth_date: '2016-01-17',
  phone_number: '090-9876-5432',
  avatar: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/box_in_cat.jpg')),
                                                 filename: '実家のネコ'),
  header: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/flower.jpg')),
                                                 filename: '花の写真'),
  self_introduction: '親猫の育児から見放されて倉庫で一人だったところを保護されて家族になった、最年少の家族。',
  user_id: mii.id
)

Follow.create(
  follower_id: admin.id,
  followed_id: coron.id
)

Notification.create(
  from_user_id: admin.id,
  to_user_id: coron.id,
  action: Notification::NOTIFICATION_ACTIONS[:follow]
)

Follow.create(
  follower_id: admin.id,
  followed_id: mii.id
)

Notification.create(
  from_user_id: admin.id,
  to_user_id: mii.id,
  action: Notification::NOTIFICATION_ACTIONS[:follow]
)

Follow.create(
  follower_id: coron.id,
  followed_id: admin.id
)

Notification.create(
  from_user_id: coron.id,
  to_user_id: admin.id,
  action: Notification::NOTIFICATION_ACTIONS[:follow]
)

Follow.create(
  follower_id: coron.id,
  followed_id: mii.id
)

Notification.create(
  from_user_id: coron.id,
  to_user_id: mii.id,
  action: Notification::NOTIFICATION_ACTIONS[:follow]
)

Follow.create(
  follower_id: mii.id,
  followed_id: coron.id
)

Notification.create(
  from_user_id: mii.id,
  to_user_id: coron.id,
  action: Notification::NOTIFICATION_ACTIONS[:follow]
)

admin_first_tweet = Tweet.create(
  text: '私が管理人だ！',
  user_id: admin.id
)

Favorite.create(
  tweet_id: admin_first_tweet.id,
  user_id: coron.id
)

Favorite.create(
  tweet_id: admin_first_tweet.id,
  user_id: mii.id
)

Tweet.create(
  text: 'みんな、好き好きにつぶやいてくれ',
  user_id: admin.id
)

mii_request_tweet = Tweet.create(
  text: '爪とぎを新しくしてくれ',
  user_id: mii.id
)

Favorite.create(
  tweet_id: mii_request_tweet.id,
  user_id: admin.id
)

Notification.create(
  from_user_id: admin.id,
  to_user_id: mii.id,
  action: Notification::NOTIFICATION_ACTIONS[:favorite],
  tweet_id: mii_request_tweet.id
)

admin_allow_to_mii = Tweet.create(
  text: 'かしこまり',
  parent_id: mii_request_tweet.id,
  user_id: admin.id
)

Notification.create(
  from_user_id: admin.id,
  to_user_id: coron.id,
  action: Notification::NOTIFICATION_ACTIONS[:reply],
  tweet_id: mii_request_tweet.id,
  reply_id: admin_allow_to_mii.id
)

coron_request_tweet = Tweet.create(
  text: 'ドッグフードより肉がいい',
  user_id: coron.id
)

admin_reply_tweet_to_coron = Tweet.create(
  text: 'りょうかいした',
  parent_id: coron_request_tweet.id,
  user_id: admin.id
)

Notification.create(
  from_user_id: admin.id,
  to_user_id: coron.id,
  action: Notification::NOTIFICATION_ACTIONS[:reply],
  tweet_id: coron_request_tweet.id,
  reply_id: admin_reply_tweet_to_coron.id
)

coron_matsusaka_reply_to_admin = Tweet.create(
  text: '松坂牛でよろ',
  parent_id: admin_reply_tweet_to_coron.id,
  user_id: coron.id
)

Notification.create(
  from_user_id: coron.id,
  to_user_id: admin.id,
  action: Notification::NOTIFICATION_ACTIONS[:reply],
  tweet_id: admin_reply_tweet_to_coron.id,
  reply_id: coron_matsusaka_reply_to_admin.id
)

Favorite.create(
  tweet_id: coron_request_tweet.id,
  user_id: admin.id
)

Notification.create(
  from_user_id: admin.id,
  to_user_id: coron.id,
  action: Notification::NOTIFICATION_ACTIONS[:favorite],
  tweet_id: coron_request_tweet.id
)

Tweet.create(
  text: '散歩あんまり好きじゃないんよ',
  user_id: coron.id
)

mii_dont_touch_tweet = Tweet.create(
  text: '気が向かんときは触るな',
  user_id: mii.id
)

Retweet.create(
  tweet_id: mii_dont_touch_tweet.id,
  user_id: admin.id
)

Notification.create(
  from_user_id: admin.id,
  to_user_id: mii.id,
  action: Notification::NOTIFICATION_ACTIONS[:retweet],
  tweet_id: mii_dont_touch_tweet.id
)

mii_bite_tweet = Tweet.create(
  text: '今日は噛みつきたい気分',
  user_id: mii.id
)

Retweet.create(
  tweet_id: mii_bite_tweet.id,
  user_id: admin.id
)

Notification.create(
  from_user_id: admin.id,
  to_user_id: mii.id,
  action: Notification::NOTIFICATION_ACTIONS[:retweet],
  tweet_id: mii_bite_tweet.id
)

Tweet.create(
  text: 'あれ。。あんまり懐いてない。。？おやつあげるわ！な！！',
  user_id: admin.id
)

Tweet.create(
  text: 'いい心がけだ。それだけもらったら用済みやけどな',
  user_id: mii.id
)

coron_snack_tweet = Tweet.create(
  text: 'おやつ！おやつ！！！',
  user_id: coron.id
)

Retweet.create(
  tweet_id: coron_snack_tweet.id,
  user_id: mii.id
)

Notification.create(
  from_user_id: mii.id,
  to_user_id: coron.id,
  action: Notification::NOTIFICATION_ACTIONS[:retweet],
  tweet_id: coron_snack_tweet.id
)

Tweet.create(
  text: 'ふっ、コロンはちょろいな。ういやつめ',
  user_id: admin.id
)

Tweet.create(
  text: 'それに引き換え、、、、みぃは難攻不落や',
  user_id: admin.id
)

mii_feign_ignorance_tweet = Tweet.create(
  text: 'おい、頭撫でろや',
  user_id: mii.id
)

Retweet.create(
  tweet_id: mii_feign_ignorance_tweet.id,
  user_id: coron.id
)

Notification.create(
  from_user_id: coron.id,
  to_user_id: mii.id,
  action: Notification::NOTIFICATION_ACTIONS[:retweet],
  tweet_id: mii_feign_ignorance_tweet.id
)

Tweet.create(
  text: '急激なデレ。これがネコのええところやなぁ、、',
  user_id: admin.id
)

Tweet.create(
  text: 'あ、もうええわ。これ以上は触んな。',
  user_id: mii.id
)

Tweet.create(
  text: '急激なツン。高低差激しすぎて、、',
  user_id: admin.id
)

Tweet.create(
  text: '私も撫でて。',
  user_id: coron.id
)

Tweet.create(
  text: 'おうおう、お前も可愛いのぅ',
  user_id: admin.id
)

Tweet.create(
  text: '撫でる手を止めるな。ずっと撫でろ。もっと、もっとだ。',
  user_id: coron.id
)

Tweet.create(
  text: 'あの、コロンさん、手疲れてき',
  user_id: admin.id
)

Tweet.create(
  text: 'まだまだ、もっと、もっと。止めたら噛む。',
  user_id: coron.id
)

Tweet.create(
  text: 'うっす。',
  user_id: admin.id
)
