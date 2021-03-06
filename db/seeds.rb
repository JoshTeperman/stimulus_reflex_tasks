core_team = Team.create(name: 'Core')

main_user = User.create!(first_name: 'Josh', last_name: 'Teperman', email: 'josh@gmail.com', password: 'password', password_confirmation: 'password', team: core_team)
second_user = User.create!(first_name: 'Kate', last_name: 'Teperman', email: 'kate@gmail.com', password: 'password', password_confirmation: 'password', team: core_team)

users = 2.times.map do
  User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.safe_email, password: 'password', password_confirmation: 'password', team: core_team)
end

users + [main_user, second_user]

list = List.create(name: Faker::Hipster.sentence, team: core_team)

tasks = 5.times.map do
  completed = Faker::Boolean.boolean(true_ratio: 0.2)
  list.tasks.create!(
    name: Faker::Hipster.sentence,
    completed_at: completed ? Time.current : nil,
    creator: users.sample,
    completer: completed ? users.sample : nil
  )
end

10.times do
  Comment.create!(user: users.sample, commentable: tasks.sample, body: Faker::Hipster.paragraph)
end
