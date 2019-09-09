User.destroy_all

User.create!(
  email:    "gold_digger@user.com",
  password: 123456,
)

User.create!(
  email:    "saboteur@user.com",
  password: 123456,
)
