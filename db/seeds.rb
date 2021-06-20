user = User.create!(first_name: 'Josh', last_name: 'Teppo', email: 'josh@gmail.com', password: 'password', password_confirmation: 'password')

list = List.create(name: Faker::Hipster.sentence)

10.times do
  list.tasks.create!(
    name: Faker::Hipster.sentence,
    completed_at: Faker::Boolean.boolean(true_ratio: 0.2) ? Time.current : nil,
    creator: user
  )
end
