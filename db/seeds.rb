puts "USERS"
User.create!(name: "Artur", email: "artur@janusz.pl", password: "12345678")
User.create!(name: "Michał", email: "michal@janusz.pl", password: "12345678")
User.create!(name: "Tomek", email: "tomek@janusz.pl", password: "12345678")
User.create!(name: "Gosia", email: "gosia@janusz.pl", password: "12345678")

puts "PROJECTS"

p = Project.new
p.name = "Pomoc sąsiedzka"
p.description = <<-EOP
Drodzy Sąsiedzi! Nadeszła jesień liście opadły z drzew, nastała jesienna chandra...
Zadbajmy wspólnie o otoczenie, aby okolica stała się ładniejsz i sprzyjała miłym spacerom
wśród zadbanych i wolnych od brzydkich liści ścieżek. Jeżeli razem się zbieżemy pracy dużo nie będzie
a o ile przyjemniej potem! :)
EOP
p.tag_list = %w(pomoc jesień sąsiedztwo inicjatywa)
p.orbitvu_attachments << OrbitvuAttachment.new(url: "http://orbitvu.co/001/oKhU3v6xjqFT3hDHQC3RBQ/")
p.logo = Rack::Test::UploadedFile.new('fixtures/pictures/leaves.jpg')
p.map_marker = ProjectLocation.new(state: "Śląskie", city: "Gliwice")
p.user = User.find_by(email: "artur@janusz.pl")
p.save!
puts "+1"
# -------------------------------------------------------------
p = Project.new
p.name = "Klasyki"
p.description = <<-EOP
Kochasz samochody z duszą? Mam dla Ciebie super informację! W najbliższą niedzielę w okolicach Trzech Stawów
odbędzie się zjazd fanów legend motoryzacji, a co za tym idzie, będziesz mieć okazję zobaczyć je na żywo i cyknąć
z nimi #selfie! Widzimy się na miejscu! Więcej info: www/klasykimoto.pl
EOP
p.tag_list = %w(samochody auta motoryzacja meet 3stawy katowice)
p.orbitvu_attachments << OrbitvuAttachment.new(url: "http://orbitvu.co/001/axg2LECoxj55ZEHPoi9qwc/")
p.logo = Rack::Test::UploadedFile.new('fixtures/pictures/garbus.jpg')
p.map_marker = ProjectLocation.new(state: "Śląskie", city: "Katowice")
p.user = User.find_by(email: "michal@janusz.pl")
p.save!
puts "+1"
# -------------------------------------------------------------
p = Project.new
p.name = "Zbiórka zabawek dla Dzieci z Domu Dziecka"
p.description = <<-EOP
Z okazji zbliżających się mikołajek fajnie by było zrobić coś miłego dla innych i wysłać zbiorową paczkę z zabawkami 
oraz grami dla dzieci z Domu Dziecka w Mysłowicach. Zbiórka odbędzie się w dniach 3-5 grudnia 2014r. 
w Szkole Podstawowej nr 1 w Mysłowicach. Każdy nawet najmniejszy drobiazg się liczy! Okażmy serce!
EOP
p.tag_list = %w(pomoc charytatywne inicjatywa dzieci mysłowice)
p.orbitvu_attachments << OrbitvuAttachment.new(url: "http://orbitvu.co/001/h6fnEGASK9NQLsp37ewCDi/")
p.logo = Rack::Test::UploadedFile.new('fixtures/pictures/santa.jpg')
p.map_marker = ProjectLocation.new(state: "Śląskie", city: "Mysłowice", street: "Wesoła", street_number: 21)
p.user = User.find_by(email: "gosia@janusz.pl")
p.save!
puts "+1"
# -------------------------------------------------------------
p = Project.new
p.name = "Odnówmy odnalezone skarby!"
p.description = <<-EOP
Jak większość z Was wie, miesiąc temu podczas prac restauracyjnych w zamku w Będzinie odnaleziono skarby sprzed ponad 200lat. 
Nie pozwólmy im niszczeć dalej! Potrzebne są pieniądze na ich odnowę, 
które można uzyskać pod warunkiem poparcia tego przedsięwzięcia przez ponad 1000 mieszkańców. 
Podpisz petycję już teraz: ankiety.pl/hehebedzinlol
EOP
p.tag_list = %w(skarby kultura fundusze będzin)
p.orbitvu_attachments << OrbitvuAttachment.new(url: "http://orbitvu.co/001/FBWjxR4YjUtooyHphDfuUn/")
p.logo = Rack::Test::UploadedFile.new('fixtures/pictures/geld.jpg')
p.map_marker = ProjectLocation.new(state: "Śląskie", city: "Będzin", street: "Zamkowa", street_number: 1)
p.user = User.find_by(email: "tomek@janusz.pl")
p.save!
puts "+1"

puts "DONE"