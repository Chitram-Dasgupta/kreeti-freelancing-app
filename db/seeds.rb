# frozen_string_literal: true

category_names = ['Web Design', 'Web Development', 'Content Writing', 'Project Management', 'SEO Service', 'Marketing',
                  'Business Analysis', 'Android Development', 'iOS Development', 'Technical Support', 'Graphic Design',
                  'UI/UX Design', 'Copywriting', 'Social Media Marketing', 'Email Marketing', 'Data Analysis',
                  'Game Development']

category_names.each do |name|
  Category.create!(name:)
end

User.create!(username: 'admin', email: 'admin@email.com', password: '123456', password_confirmation: '123456',
             role: 'admin', email_confirmed: true, confirmation_token: nil, status: 'approved')

(1..25).each do |i|
  client = User.create!(username: "c#{i}", email: "c#{i}@email.com", password: '123456',
                        password_confirmation: '123456', role: 'client', email_confirmed: true, confirmation_token: nil,
                        status: 'approved')

  rand(4..6).times do |j|
    project_visibility = i > 20 && j == 5 ? 'priv' : 'pub'
    project = client.projects.create!(title: "Project #{j} for Client #{i}",
                                      description: 'lorem ipsum', visibility: project_visibility)

    project.categories << Category.all.sample(rand(1..3))
  end
end

(1..75).each do |i|
  freelancer_visibility = i > 70 ? 'priv' : 'pub'
  freelancer = User.create!(username: "f#{i}", email: "f#{i}@email.com", password: '123456',
                            password_confirmation: '123456', role: 'freelancer', email_confirmed: true,
                            confirmation_token: nil, visibility: freelancer_visibility, status: 'approved')

  freelancer.categories << Category.all.sample(rand(1..5))
end

User.where(role: 'freelancer').each do |freelancer|
  project = Project.all.sample

  project.bids.create!(bid_description: 'lorem ipsum dolor', bid_amount: rand(10_000..25_000), user_id: freelancer.id)
end
