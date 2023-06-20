cat1 = Category.create!(name: 'Web Design')
cat2 = Category.create!(name: 'Web Development')
cat3 = Category.create!(name: 'Content Writing')
cat4 = Category.create!(name: 'Project Management')
cat5 = Category.create!(name: 'SEO Service')
cat6 = Category.create!(name: 'Marketing')
cat7 = Category.create!(name: 'Business Analysis')
cat8 = Category.create!(name: 'Android Development')
cat9 = Category.create!(name: 'iOS Development')
cat10 = Category.create!(name: 'Technical Support')

User.create!(email: 'admin@example.com', password: '123456', password_confirmation: '123456', role: 'admin',
             email_confirmed: true, confirmation_token: nil)

c1 = User.create!(email: 'c1@email.com', password: '123456', password_confirmation: '123456', role: 'client',
                  email_confirmed: true, confirmation_token: nil)

c2 = User.create!(email: 'c2@email.com', password: '123456', password_confirmation: '123456', role: 'client',
                  email_confirmed: true, confirmation_token: nil)

c3 = User.create!(email: 'c3@email.com', password: '123456', password_confirmation: '123456', role: 'client',
                  email_confirmed: true, confirmation_token: nil)

c4 = User.create!(email: 'c4@email.com', password: '123456', password_confirmation: '123456', role: 'client',
                  email_confirmed: true, confirmation_token: nil)

f1 = User.create!(email: 'f1@email.com', password: '123456', password_confirmation: '123456', role: 'freelancer',
                  email_confirmed: true, confirmation_token: nil)
f1.categories << cat1 << cat2 << cat10

f2 = User.create!(email: 'f2@email.com', password: '123456', password_confirmation: '123456', role: 'freelancer',
                  email_confirmed: true, confirmation_token: nil)
f2.categories << cat2 << cat4 << cat5 << cat6 << cat7

p1 = c1.projects.create!(title: 'Web Design project', description: 'lorem ipsum')
p1.categories << cat1 << cat2

p2 = c2.projects.create!(title: 'Web Development project', description: 'lorem ipsum')
p2.categories << cat2 << cat3

p3 = c3.projects.create!(title: 'Content Writing project', description: 'lorem ipsum')
p3.categories << cat4 << cat5

p4 = c4.projects.create!(title: 'Project Management project', description: 'lorem ipsum')
p4.categories << cat6 << cat7 << cat8

p5 = c4.projects.create!(title: 'SEO Service project', description: 'lorem ipsum')
p5.categories << cat9 << cat10
