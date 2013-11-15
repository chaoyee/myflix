# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: "chaoyee@test.com", password: 'password', full_name: "Charles Hsu")
User.create(email: "test@test.com", password: 'password', full_name: "Tester Lee")


Video.create(title: 'The Shield', description: 'This gritty crime drama follows Detective Vic Mackey (Michael Chiklis) as he leads a group of detectives known as the Strike Team throughout the crime ridden streets of California. Though is goal of stopping crime at its source is admirable, his methods are anything but on the straight and narrow, and become increasingly corrupt as time goes on. Romantic relationships are equally difficult to navigate; Mackey marriage falters due to several indiscretions, as well as the stress of paying for the education of a special needs child. ', small_cover_url: '/img/the_shield_225x225.jpg', large_cover_url: '/img/the_shield_1000x1000.jpg', category_id: 1)
Video.create(title: 'Supernatural', description: 'After a year apart, Sam and Dean are reunited in the Eighth Season premiere. After escaping from Purgatory with the help of a vampire named Benny, Dean heads straight for Sam, but the reunion is not exactly everything he imagined it would be. Although Sam drops everything to join his brother, leaving the life he had grown accustomed to enjoy turns out to be harder than he imagined. In the meantime, Benny help turns out to be more than what Dean bargained for. ', small_cover_url: '/img/supernatural_small.jpg', large_cover_url: '/img/supernatural_large.jpg', category_id: 2)
Video.create(title: 'Gladiator', description: 'Watch one of the best award-winning movies of all time, the Ridley Scott directed "Gladiator" coming to you in a Blu-ray two-disc set. Starring Oscar-winning actor Russel Crowe, this historical drama takes place in the year 180 when the Roman emperor Marcus Aurelius angers his devious son Commodus by making his army general Maximus the sole caretaker of the throne. As Commodus ascends the throne by murdering his father, sentencing Maximus execution and killing his family, Maximus escapes. ', small_cover_url: '/img/gladiator_small.jpg', large_cover_url: '/img/gladiator_large.jpg', category_id: 1)

Video.create(title: 'Bones', description: 'Bones was one of several series which popped up in the wake of CSI: Crime Scene Investigation, a show which reinvigorated the procedural and perhaps, like the iconic Mission: Impossible series of decades ago, tended to emphasize plot over character.', small_cover_url: '/img/bones_small.jpg', large_cover_url: '/img/bones_large.jpg', category_id: 2)
Video.create(title: 'NCIS: The Tenth Season', description: "The tenth season of NCIS (Naval Criminal Investigative Service) continues to follow an unlikely team of special agents who are forced to put their differences aside in dealing with a continuous onslaught of life-and-death situations ranging from murder, espionage, and terrorism on the high seas.", small_cover_url: '/img/ncis_small.jpg', large_cover_url: '/img/ncis_large.jpg', category_id: 1)
Video.create(title: 'Castle', description: "Following four seasons of sexual tension between Castle (Nathan Fillion) and Beckett (Stana Katic), the fifth season opens with the two of them finally embarking on a romantic relationship together. However, they try to keep this new relationship a secret, particularly from their boss, Capt. Victoria Gates (Penny Johnson Jerald). Also, Beckett finally discovers who's responsible for her mother's murder and wrestles with whether she should carry out her personal vendetta against him.", small_cover_url: '/img/castle_small.jpg', large_cover_url: '/img/castle_large.jpg', category_id:2)
Video.create(title: 'Spirited Away', description: "Directed by animation legend Hayao Miyazaki, SPIRITED AWAY is the tale of Chihiro (voiced by Daveigh Chase), a young girl who is taken down an unusual road by her parents while moving to a new home in an unfamiliar town. The curiosity of Chihiro's mother (Lauren Holly) and father (Michael Chiklis) leads the reluctant child into what appears to be an abandoned amusement park. Soon her parents are greedily feasting on various delights from an enticing food stand and are literally turned into pigs. The frightened and bewildered girl then encounters a young man named Haku (Jason Marsden), who explains what she must do to navigate this strange and magical realm.", small_cover_url: '/img/spirited_away_small.jpg', large_cover_url: '/img/spirited_away_large.jpg', category_id: 3)
Video.create(title: 'Toy Story', description: "A cowboy doll is profoundly threatened and jealous when a new spaceman figure supplants him as top toy in a boy's room.", small_cover_url: '/img/toy_story_small.jpg', large_cover_url: '/img/toy_story_large.jpg', category_id: 3)
Video.create(title: 'Toy Story 2', description: "When Woody is stolen by a toy collector, Buzz and his friends vow to rescue him, but Woody finds the idea of immortality in a museum tempting.", small_cover_url: '/img/toy_story2_small.jpg', large_cover_url: '/img/toy_story2_large.jpg', category_id: 3)
Video.create(title: 'Toy Story 3', description: "The toys are mistakenly delivered to a day-care center instead of the attic right before Andy leaves for college, and it's up to Woody to convince the other toys that they weren't abandoned and to return home.", small_cover_url: '/img/toy_story3_small.jpg', large_cover_url: '/img/toy_story3_large.jpg', category_id: 3)
Video.create(title: 'My Neighbour Totoro', description: "When two girls move to the country to be near their ailing mother, they have adventures with the wonderous forest spirits who live nearby.", small_cover_url: '/img/totoro_small.jpg', large_cover_url: '/img/totoro_large.jpg', category_id: 3)
Video.create(title: "Howl's Moving Castle", description: "When an unconfident young woman is cursed with an old body by a spiteful witch, her only chance of breaking the spell lies with a self-indulgent yet insecure young wizard and his companions in his legged, walking home.", small_cover_url: '/img/howl_moving_castle_small.jpg', large_cover_url: '/img/howl_moving_castle_large.jpg', category_id: 3)
Video.create(title: "The Truman Show", description: "An insurance salesman/adjuster discovers his entire life is actually a TV show.", small_cover_url: '/img/the_truman_show_small.jpg', large_cover_url: '/img/the_truman_show_large.jpg', category_id:1)
Video.create(title: "Bruce Almighty", description: "A guy who complains about God too often is given almighty powers to teach him how difficult it is to run the world.", small_cover_url: '/img/bruce_almighty_small.jpg', large_cover_url: '/img/bruce_almighty_large.jpg', category_id:1)
Video.create(title: "Bean The Movie", description: "The bumbling Mr. Bean travels to America when he is given the responsibility of bringing a highly valuable painting to a Los Angeles museum.", small_cover_url: '/img/bean_small.jpg', large_cover_url: '/img/bean_large.jpg', category_id:1)
Video.create(title: "The Internship", description: "Two salesmen whose careers have been torpedoed by the digital age find their way into a coveted internship at Google, where they must compete with a group of young, tech-savvy geniuses for a shot at employment.", small_cover_url: '/img/the_internship_small.jpg', large_cover_url: '/img/the_internship_large.jpg', category_id:2)
Video.create(title: "Forrest Gump", description: "Forrest Gump, while not intelligent, has accidentally been present at many historic moments, but his true love, Jenny Curran, eludes him.", small_cover_url: '/img/forrest_gump_small.jpg', large_cover_url: '/img/forrest_gump_large.jpg', category_id:2)
Video.create(title: "Saving Private Ryan", description: "Following the Normandy Landings, a group of U.S. soldiers go behind enemy lines to retrieve a paratrooper whose brothers have been killed in action.", small_cover_url: '/img/saving_private_ryan_small.jpg', large_cover_url: '/img/saving_private_ryan_large.jpg', category_id:2)

Category.create(name: 'Movie Comedies')
Category.create(name: 'Movie Dramas')
Category.create(name: 'Movie Animation')

Review.create(user_id: 1, video_id: 2, rating: 4, content: "A GREAT movie!")
Review.create(user_id: 2, video_id: 2, rating: 5, content: "A GREAT GREAT movie!")

QueueItem.create(video_id: 2, user_id: 1, position: 1)
QueueItem.create(video_id: 2, user_id: 2, position: 2) 
