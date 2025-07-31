# Create sample users
puts "Creating sample users..."

users = [
  { username: "alice", email: "alice@example.com", password: "password123" },
  { username: "bob", email: "bob@example.com", password: "password123" },
  { username: "charlie", email: "charlie@example.com", password: "password123" },
  { username: "diana", email: "diana@example.com", password: "password123" },
  { username: "edward", email: "edward@example.com", password: "password123" }
]

users.each do |user_attrs|
  user = User.find_or_create_by(email: user_attrs[:email]) do |u|
    u.username = user_attrs[:username]
    u.password = user_attrs[:password]
    u.password_confirmation = user_attrs[:password]
  end
  puts "Created user: #{user.username}"
end

# Create some sample friendships
puts "Creating sample friendships..."

alice = User.find_by(username: "alice")
bob = User.find_by(username: "bob")
charlie = User.find_by(username: "charlie")
diana = User.find_by(username: "diana")

# Alice and Bob are friends
if alice && bob
  Friendship.find_or_create_by(user: alice, friend: bob) do |f|
    f.status = "accepted"
  end
  puts "Alice and Bob are now friends"
end

# Charlie and Diana are friends
if charlie && diana
  Friendship.find_or_create_by(user: charlie, friend: diana) do |f|
    f.status = "accepted"
  end
  puts "Charlie and Diana are now friends"
end

# Alice has a pending request from Charlie
if alice && charlie
  Friendship.find_or_create_by(user: charlie, friend: alice) do |f|
    f.status = "pending"
  end
  puts "Charlie sent a friend request to Alice"
end

puts "Seed data created successfully!"
