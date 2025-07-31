# Yo - Friend Notification App

A Rails application that allows users to add friends and send push notifications to their devices.

## Features

- **User Authentication**: Sign up, sign in, and manage your account
- **Friend Management**: Add friends, accept/reject friend requests
- **Push Notifications**: Send instant notifications to friends' devices
- **Real-time Alerts**: Notifications with sound and visual alerts
- **Responsive Design**: Works on desktop and mobile devices

## Getting Started

### Prerequisites

- Ruby 3.0 or higher
- Rails 8.0 or higher
- SQLite3
- Node.js (for JavaScript dependencies)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd yo
```

2. Install dependencies:
```bash
bundle install
```

3. Set up the database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. Start the Rails server:
```bash
rails server
```

5. Visit `http://localhost:3000` in your browser

### Sample Data

The application comes with sample users for testing:

- **alice@example.com** / password123
- **bob@example.com** / password123
- **charlie@example.com** / password123
- **diana@example.com** / password123
- **edward@example.com** / password123

## Usage

### Adding Friends

1. Sign in to your account
2. Navigate to "Friends" in the navigation
3. Browse available users and click "Add Friend"
4. Wait for your friend request to be accepted

### Sending Push Notifications

1. Go to "Send Notification" in the navigation
2. Select a friend from the dropdown
3. Enter your message
4. Click "Send Notification"

### Enabling Push Notifications

1. Go to "Settings" in the navigation
2. Click "Enable Push Notifications"
3. Allow notifications in your browser
4. Your device will now receive notifications

## Technical Details

### Models

- **User**: Handles authentication and user data
- **Friendship**: Manages friend relationships with status (pending/accepted/rejected)
- **PushSubscription**: Stores push notification subscription data

### Controllers

- **HomeController**: Dashboard for authenticated users
- **FriendshipsController**: Manage friend relationships
- **PushNotificationsController**: Send notifications to friends
- **SettingsController**: User settings and push notification setup
- **API Controllers**: Handle push subscription management

### Push Notifications

The app uses the Web Push API to send notifications:

1. Users enable push notifications in their browser
2. Subscription data is stored in the database
3. Friends can send notifications through the web interface
4. Notifications appear with sound and visual alerts

### Service Worker

A service worker (`public/service-worker.js`) handles:
- Receiving push notifications
- Displaying notifications to users
- Handling notification clicks

## Development

### Adding New Features

1. Create models with `rails generate model`
2. Add controllers with `rails generate controller`
3. Update routes in `config/routes.rb`
4. Create views in `app/views/`
5. Add styles in `app/assets/stylesheets/`

### Testing

Run the test suite:
```bash
rails test
```

### Database

Reset the database:
```bash
rails db:reset
```

## Deployment

### Environment Variables

Set up VAPID keys for push notifications:
```bash
rails credentials:edit
```

Add your VAPID keys:
```yaml
vapid_public_key: your_public_key_here
vapid_private_key: your_private_key_here
```

### Production Considerations

- Use a production database (PostgreSQL recommended)
- Set up proper SSL certificates
- Configure VAPID keys for push notifications
- Set up proper email configuration for Devise

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please open an issue on GitHub or contact the development team.
