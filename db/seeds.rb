Order.destroy_all
Guitar.destroy_all
User.destroy_all

user1 = User.create(email: "joao@gmail.com", password: "123123")
user2 = User.create(email: "paulo@gmail.com", password: "123123")
user3 = User.create(email: "cesar@gmail.com", password: "123123")
user4 = User.create(email: "joana@gmail.com", password: "123123")
user5 = User.create(email: "juliana@gmail.com", password: "123123")

brands = ["Gibson", "Fender", "ibanez"]
models = ["Explorer", "Les Paul", "Telecaster", "Stratocaster", "AF"]
materials = ["Walnut", "Mahogany"]
pickups = ["Classic Elite (H)", "V-MOD II"]
countries = ["USA", "France", "Thailand"]

User.all.each do |user|
  2.times do
    year = rand(1950.. 2023)
    brand = brands.sample
    model = models.sample
    Guitar.create!(
      name: "#{brand} #{model} #{year}",
      brand: brand,
      model: model,
      description: Faker::Lorem.paragraph,
      material: materials.sample,
      pickup: pickups.sample,
      right_handed: true,
      year: year,
      country: countries.sample,
      price_per_day: rand(10..500),
      user: user
    )
  end
end

10.times do |i|
  seller = User.all.sample
  guitar = seller.guitars.sample
  buyer = User.all.reject{|user| user.id == seller.id}.sample
  start = Date.today + rand(-90..+90)
  days = rand(1..30)
  Order.create!(
    guitar: guitar,
    user: buyer,
    price: days * guitar.price_per_day,
    start_date: start,
    end_date: start + days
  )
end
