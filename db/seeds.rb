Order.destroy_all
Guitar.destroy_all
User.destroy_all

User.create(email: "joao@gmail.com", password: "123123")
User.create(email: "paulo@gmail.com", password: "123123")
User.create(email: "alphadeny@hotmail.fr", password: "123123")
User.create(email: "thiago@olatu.com", password: "123123")
User.create(email: "juliavdheyde@icloud.com", password: "123123")

brands = ["Gibson", "Fender", "Ibanez"]
models = ["Explorer", "Les Paul", "Telecaster", "Stratocaster", "Jazzmaster", "AF"]
materials = ["Walnut", "Mahogany"]
pickups = ["Classic Elite (H)", "V-MOD II"]
countries = ["USA", "France", "Thailand"]

User.all.each do |user|
  2.times do
    year = rand(1950.. 2023)
    brand = brands.sample
    index = brands.index {|e| e == brand}
    case index
    when 0
      model = models[0..1].sample
    when 1
      model = models[2..4].sample
    when
      model = models[5]
    end
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
