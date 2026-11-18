# ---------- Марки ----------
brands_data = {
  "Volkswagen" => "Німеччина",
  "Škoda"      => "Чехія",
  "Audi"       => "Німеччина",
  "BMW"        => "Німеччина",
  "Toyota"     => "Японія",
  "Chevrolet"  => "США",
  "Dodge"      => "США",
  "Subaru"     => "Японія",
  "Honda"      => "Японія",
  "Volvo"      => "Швеція",
  "Saab"       => "Швеція"
}

brands = brands_data.to_h do |name, country|
  [ name, Brand.find_or_create_by!(name: name) { |b| b.country = country } ]
end

# ---------- Автомобілі ----------
cars_data = [
  { brand: "Volkswagen", name: "Passat B8", year: 2024, price: 38_500, body_type: "Седан",
    engine: "2.0 TDI", horsepower: 150, transmission: "Автомат (DSG)", drive: "Передній", color: "Сірий",
    description: "Класичний бізнес-седан: просторий салон, економічний дизель і спокійна їзда на довгих дистанціях." },

  { brand: "Volkswagen", name: "Passat Alltrack", year: 2024, price: 46_900, body_type: "Універсал",
    engine: "2.0 TDI", horsepower: 200, transmission: "Автомат (DSG)", drive: "Повний (4Motion)", color: "Зелений",
    description: "Підвищений універсал з повним приводом для тих, кому тісно на асфальті." },

  { brand: "Škoda", name: "Superb", year: 2024, price: 41_200, body_type: "Ліфтбек",
    engine: "2.0 TSI", horsepower: 190, transmission: "Автомат (DSG)", drive: "Передній", color: "Чорний",
    description: "Найбільший багажник у класі та салон, у якому вистачає місця всім пасажирам." },

  { brand: "Audi", name: "A5 Sportback", year: 2024, price: 52_800, body_type: "Ліфтбек",
    engine: "2.0 TFSI", horsepower: 204, transmission: "Автомат (S tronic)", drive: "Повний (quattro)", color: "Білий",
    description: "Спортивний силует, віртуальна панель приладів і фірмовий повний привід quattro." },

  { brand: "BMW", name: "330i", year: 2024, price: 54_500, body_type: "Седан",
    engine: "2.0 Turbo", horsepower: 258, transmission: "Автомат", drive: "Задній", color: "Синій",
    description: "Еталон керованості серед седанів: точне рульове керування й задній привід." },

  { brand: "Toyota", name: "GR86", year: 2024, price: 33_900, body_type: "Купе",
    engine: "2.4 Boxer", horsepower: 234, transmission: "Механіка (6)", drive: "Задній", color: "Жовтий",
    description: "Легке заднєприводне купе для чистого водійського задоволення." },

  { brand: "Chevrolet", name: "Camaro SS", year: 2023, price: 48_700, body_type: "Купе",
    engine: "6.2 V8", horsepower: 455, transmission: "Автомат (10)", drive: "Задній", color: "Червоний",
    status: :reserved,
    description: "Американський мускул-кар з атмосферним V8 і характерним звуком." },

  { brand: "Dodge", name: "Challenger R/T", year: 2023, price: 44_300, body_type: "Купе",
    engine: "5.7 HEMI V8", horsepower: 375, transmission: "Автомат (8)", drive: "Задній", color: "Помаранчевий",
    description: "Ретро-дизайн, великий салон і V8, який чути за квартал." },

  { brand: "Subaru", name: "Outback", year: 2024, price: 36_800, body_type: "Універсал",
    engine: "2.5 Boxer", horsepower: 182, transmission: "Варіатор (CVT)", drive: "Повний (Symmetrical AWD)", color: "Зелений",
    description: "Надійний повний привід і дорожній просвіт для будь-якої погоди." },

  { brand: "Honda", name: "Civic Type R", year: 2024, price: 47_600, body_type: "Хетчбек",
    engine: "2.0 VTEC Turbo", horsepower: 329, transmission: "Механіка (6)", drive: "Передній", color: "Білий",
    description: "Найшвидший передньоприводний хетчбек, створений для треку, але придатний для щоденних поїздок." },

  { brand: "Volvo", name: "V60 B4", year: 2024, price: 49_900, body_type: "Універсал",
    engine: "2.0 Mild Hybrid", horsepower: 197, transmission: "Автомат (8)", drive: "Передній", color: "Сірий",
    description: "Скандинавська безпека, мінімалістичний салон і м'яка гібридна силова установка." },

  { brand: "Saab", name: "9-3 Aero", year: 2011, price: 29_900, body_type: "Седан",
    engine: "2.8 V6 Turbo", horsepower: 280, transmission: "Автомат", drive: "Повний (XWD)", color: "Синій",
    description: "Колекційна рідкість: новий автомобіль із довготривалого зберігання, без пробігу." }
]

cars_data.each do |attrs|
  brand = brands.fetch(attrs[:brand])
  Car.find_or_create_by!(brand: brand, name: attrs[:name], year: attrs[:year]) do |car|
    car.assign_attributes(attrs.except(:brand))
  end
end

# ---------- Філії салону (вигадані адреси для навчального проєкту) ----------
[
  { name: "J-Drive Івано-Франківськ", city: "Івано-Франківськ", address: "вул. Незалежності, 25", phone: "+380 342 00 00 01" },
  { name: "J-Drive Київ",             city: "Київ",             address: "просп. Берестейський, 100", phone: "+380 44 000 00 02" },
  { name: "J-Drive Львів",            city: "Львів",            address: "вул. Городоцька, 150", phone: "+380 32 000 00 03" }
].each do |attrs|
  Branch.find_or_create_by!(name: attrs[:name]) { |b| b.assign_attributes(attrs) }
end

puts "Марок: #{Brand.count}, авто: #{Car.count}, філій: #{Branch.count}"