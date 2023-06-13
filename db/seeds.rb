c1 = User.new(email: 'c1@email.com', password: '123456', password_confirmation: '123456', role: 'client', email_confirmed: true, confirmation_token: nil)
c1.save

c2 = User.new(email: 'c2@email.com', password: '123456', password_confirmation: '123456', role: 'client', email_confirmed: true, confirmation_token: nil)
c2.save

f1 = User.new(email: 'f1@email.com', password: '123456', password_confirmation: '123456', role: 'freelancer', email_confirmed: true, confirmation_token: nil)
f1.save

f2 = User.new(email: 'f2@email.com', password: '123456', password_confirmation: '123456', role: 'freelancer', email_confirmed: true, confirmation_token: nil)
f2.save
