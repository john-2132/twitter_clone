# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.new(
  name: 'admin',
  email: 'zumiairhc@gmail.com',
  password: ENV['CONFIRMED_USER_PASS'],
  birth_date: '1992-02-11',
  phone_number: '090-1111-2222',
  avatar: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/cat.jpg')),
                                                 filename: '小松寺の猫')
)

user.skip_confirmation!
user.save!
