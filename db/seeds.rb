# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_user = User.create(email: 'admin@example.com',
                         name: 'admin',
                         password: 'password',
                         admin: true)

Project.create(name: 'Ticketee Beta')

State.create(name: 'New',
             background: '#85FF00',
             color: 'white')
State.create(name: 'Open',
             background: '#00CFFD',
             color: 'white')
State.create(name: 'Closed',
             background: 'black',
             color: 'white')
