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
  "Volvo"      => "Швеція"
}

brands = brands_data.to_h do |name, country|
  [ name, Brand.find_or_create_by!(name: name) { |b| b.country = country } ]
end

# ---------- Автомобілі (нові, актуальні моделі) ----------
cars_data = [
  { brand: "Volkswagen", name: "Passat Variant", year: 2026, price: 42_500, body_type: "Універсал",
    engine: "2.0 TDI", horsepower: 150, transmission: "Автомат (DSG)", drive: "Передній", color: "Сірий",
    description: "Нове покоління Passat у кузові універсал: просторий салон, великий багажник і економічний дизель для довгих поїздок." },

  { brand: "Škoda", name: "Superb", year: 2026, price: 44_900, body_type: "Ліфтбек",
    engine: "2.0 TSI", horsepower: 204, transmission: "Автомат (DSG)", drive: "Передній", color: "Чорний",
    description: "Флагман Škoda з рекордним простором для пасажирів і багажником, який вміщує все для сімейної подорожі." },

  { brand: "Audi", name: "A5 Sportback", year: 2026, price: 55_800, body_type: "Ліфтбек",
    engine: "2.0 TFSI (м'яка гібридна)", horsepower: 265, transmission: "Автомат (S tronic)", drive: "Повний (quattro)", color: "Білий",
    description: "Спортивний силует, цифрова панель приладів і повний привід quattro для впевненої їзди за будь-якої погоди." },

  { brand: "BMW", name: "330i", year: 2026, price: 54_900, body_type: "Седан",
    engine: "2.0 Turbo", horsepower: 258, transmission: "Автомат (8)", drive: "Задній", color: "Синій",
    description: "Еталон керованості серед седанів бізнес-класу: точне рульове керування й класичний задній привід." },

  { brand: "Toyota", name: "GR86", year: 2026, price: 33_500, body_type: "Купе",
    engine: "2.4 Boxer", horsepower: 228, transmission: "Механіка (6)", drive: "Задній", color: "Жовтий",
    description: "Легке заднєприводне купе, створене для чистого водійського задоволення." },

  { brand: "Toyota", name: "Camry Hybrid", year: 2026, price: 35_900, body_type: "Седан",
    engine: "2.5 Hybrid", horsepower: 225, transmission: "Електронний варіатор (e-CVT)", drive: "Передній", color: "Сірий",
    description: "Класичний середній седан нового покоління. Тільки гібрид: низька витрата пального й комфорт на щодень." },

  { brand: "Chevrolet", name: "Corvette Stingray", year: 2026, price: 72_500, body_type: "Купе",
    engine: "6.2 V8", horsepower: 495, transmission: "Робот (8DCT)", drive: "Задній", color: "Червоний",
    description: "Середньомоторний американський суперкар з атмосферним V8, що змагається з європейськими конкурентами." },

  { brand: "Chevrolet", name: "Equinox RS", year: 2026, price: 36_500, body_type: "Кросовер",
    engine: "1.5 Turbo", horsepower: 175, transmission: "Автомат (6)", drive: "Передній", color: "Білий",
    description: "Сімейний кросовер у спортивній комплектації RS: просторий салон, великий екран і сучасні системи допомоги водієві." },

  { brand: "Dodge", name: "Charger Sixpack R/T", year: 2026, price: 52_000, body_type: "Седан",
    engine: "3.0 Twin-Turbo I6", horsepower: 420, transmission: "Автомат (8)", drive: "Повний (AWD)", color: "Помаранчевий",
    description: "Новий Charger з турбованою рядною шістіркою, широким кузовом у стилі класичних маслкарів і повним приводом." },

  { brand: "Subaru", name: "Outback", year: 2026, price: 37_900, body_type: "Універсал",
    engine: "2.5 Boxer", horsepower: 182, transmission: "Варіатор (CVT)", drive: "Повний (Symmetrical AWD)", color: "Зелений",
    description: "Універсал із великим дорожнім просвітом і постійним повним приводом для будь-якої погоди й бездоріжжя." },

  { brand: "Honda", name: "Civic Type R", year: 2026, price: 48_900, body_type: "Хетчбек",
    engine: "2.0 VTEC Turbo", horsepower: 329, transmission: "Механіка (6)", drive: "Передній", color: "Сірий",
    description: "Найшвидший передньоприводний хетчбек, створений для треку, але цілком придатний для щоденних поїздок." },

  { brand: "Volvo", name: "XC60 B5", year: 2026, price: 53_900, body_type: "Кросовер",
    engine: "2.0 Mild Hybrid", horsepower: 250, transmission: "Автомат (8)", drive: "Повний (AWD)", color: "Синій",
    description: "Скандинавська безпека, мінімалістичний салон і м'яка гібридна силова установка." }
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
