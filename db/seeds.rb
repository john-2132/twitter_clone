# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

admin = User.new(
  name: 'admin',
  email: 'zumiairhc@gmail.com',
  password: ENV['CONFIRMED_USER_PASS'],
  birth_date: '1992-02-11',
  phone_number: '090-1111-2222',
  avatar: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/cat.jpg')),
                                                 filename: '小松寺の猫'),
  uid: SecureRandom.uuid
)
admin.skip_confirmation!
admin.save!

coron = User.new(
  name: 'coron',
  email: 'coron@example.com',
  password: 'coron_dog',
  birth_date: '2005-12-12',
  phone_number: '090-1234-5678',
  avatar: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/dog.jpg')),
                                                 filename: '実家のトイプー'),
  uid: SecureRandom.uuid
)
coron.skip_confirmation!
coron.save!

mii = User.new(
  name: 'mii',
  email: 'mii@example.com',
  password: 'mii_cat',
  birth_date: '2016-01-17',
  phone_number: '090-9876-5432',
  avatar: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/box_in_cat.jpg')),
                                                 filename: '実家のネコ'),
  uid: SecureRandom.uuid
)
mii.skip_confirmation!
mii.save!

Follow.create(
  follower_id: admin.id,
  followed_id: coron.id
)

Follow.create(
  follower_id: admin.id,
  followed_id: mii.id
)

Follow.create(
  follower_id: coron.id,
  followed_id: admin.id
)

Follow.create(
  follower_id: coron.id,
  followed_id: mii.id
)

Follow.create(
  follower_id: mii.id,
  followed_id: coron.id
)

Tweet.create(
  text: '私が管理人だ！',
  user_id: admin.id
)

Tweet.create(
  text: 'みんな、好き好きにつぶやいてくれ',
  user_id: admin.id
)

Tweet.create(
  text: '爪とぎを新しくしてくれ',
  user_id: mii.id
)

Tweet.create(
  text: 'ドッグフードより肉がいい',
  user_id: coron.id
)

Tweet.create(
  text: '散歩あんまり好きじゃないんよ',
  user_id: coron.id
)

Tweet.create(
  text: '気が向かんときは触るな',
  user_id: mii.id
)

Tweet.create(
  text: '今日は噛みつきたい気分',
  user_id: mii.id
)

Tweet.create(
  text: 'あれ。。あんまり懐いてない。。？おやつあげるわ！な！！',
  user_id: admin.id
)

Tweet.create(
  text: 'いい心がけだ。それだけもらったら用済みやけどな',
  user_id: mii.id
)

Tweet.create(
  text: 'おやつ！おやつ！！！',
  user_id: coron.id
)

Tweet.create(
  text: 'ふっ、コロンはちょろいな。ういやつめ',
  user_id: admin.id
)

Tweet.create(
  text: 'それに引き換え、、、、みぃは難攻不落や',
  user_id: admin.id
)

Tweet.create(
  text: 'おい、頭撫でろや',
  user_id: mii.id
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
