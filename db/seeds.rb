main_user = User.create!(first_name: 'Josh', last_name: 'Teperman', email: 'josh@gmail.com', password: 'password', password_confirmation: 'password')

users = 5.times.map do
  User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.safe_email, password: 'password', password_confirmation: 'password')
end

users << main_user

list = List.create(name: Faker::Hipster.sentence)

10.times do
  completed = Faker::Boolean.boolean(true_ratio: 0.2)
  list.tasks.create!(
    name: Faker::Hipster.sentence,
    completed_at: completed ? Time.current : nil,
    creator: users.sample,
    completer: completed ? users.sample : nil
  )
end
