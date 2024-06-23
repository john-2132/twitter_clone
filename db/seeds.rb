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
  phone_number: '090-1111-2222'
)

user.skip_confirmation!
user.save!
