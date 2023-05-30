Order.destroy_all
Guitar.destroy_all
User.destroy_all

User.create!(first_name: "Joao", last_name: "De la Vegas", email: "joao@gmail.com", password: "123123")
User.create!(first_name: "Paulo", last_name: "De la Bamba", email: "paulo@gmail.com", password: "123123")
User.create!(first_name: "Alphonse", last_name: "Black Mamba", email: "alphadeny@hotmail.fr", password: "123123")
User.create!(first_name: "Thiago", last_name: "Cucaracha", email: "thiago@olatu.com", password: "123123")
User.create!(first_name: "Julia", last_name: "Senhorita", email: "juliavdheyde@icloud.com", password: "123123")

brands = ["Gibson", "Fender", "Ibanez"]
models = ["Explorer", "Les Paul", "Telecaster", "Stratocaster", "Jazzmaster", "AF"]
materials = ["Walnut", "Mahogany"]
pickups = ["Classic Elite (H)", "V-MOD II"]
countries = ["USA", "France", "Thailand"]
cities = ["Sao Paulo", "Rio de Janeiro"]

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
      rental_city: cities.sample,
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
