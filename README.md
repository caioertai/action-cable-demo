# Action Cable Demo

A quick demo was done at Le Wagon Melbourne batch#295. Starting from scratch using [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

## Usage
Onboarding:
```bash
  bundle install
  yarn install
  rails db:create db:migrate db:seed
```
Using the app:
- `rails s`
- Go to http://localhost:3000/
- Open http://localhost:3000/ again on another window or a private browser window
- Login on one side as: `email: gold_digger@user.com, password: 123456`
- Login on the other as: `email: saboteur@user.com, password: 123456`
- Clicking the buttons broadcasts a message to the relevant users.

## Step by step setup
Starting from the official Le Wagon templates ([lewagon/rails-templates](https://github.com/lewagon/rails-templates)).

Following the [commit history](https://github.com/caioertai/action-cable-demo/commits/batch-295) on this repo gives a pretty good visual representation of the steps. But I'll go over some details and reasoning in here.

### 1. [Action Cable Config](https://github.com/caioertai/action-cable-demo/commit/0635d495191f610b87e9507b04fc65dac88178a8)
- Check [the diff on cable.yml](https://github.com/caioertai/action-cable-demo/commit/0635d495191f610b87e9507b04fc65dac88178a8#diff-28d817d42286743ad34416c4ae612dbf) for the needed changes.
  - Async is the default adapter for ActionCable, but I prefer using Redis, which is an easy setup (check the Background Jobs lecture on Kitt if you're missing it) and it's as well the same adapter we're using in production anyway.
  - Also, notice that the production URL for redis is updated to use the default [Redis Cloud addon on Heroku](https://elements.heroku.com/addons/rediscloud).
- Install ActionCable using yarn: `yarn add @rails/actioncable`.
  - Don't mind the diffs on `package.json` and `yarn.lock` those are going to be updated by the yarn command.
  - The template for this demo uses Rails 5.2.3, which still defaults to the sprockets JS asset pipeline. But I recommend using the modern ActionCable 6.0 version via webpack even on Rails 5.

### 2. [Setup ActionCable Connection for devise](https://github.com/caioertai/action-cable-demo/commit/e674162dd29f140fbdeb76b91a4897af0766ce73)
- Just [follow the diff](https://github.com/caioertai/action-cable-demo/commit/e674162dd29f140fbdeb76b91a4897af0766ce73#diff-915d99197df5caa102c51760df5a7029).
  - The default Rails way for authenticating the user via ActionCable uses encrypted cookies, but `warden` (which devise uses) has a different approach. These lines should give you seamless access to the `current_user` helper on your channels.

### 3. [Create a Server side channel file - my_channel.rb](https://github.com/caioertai/action-cable-demo/commit/d39fca60880f0160f55691c64d778ab66bd4cd4f)
- Run `rails g channel <MY_CHANNEL_NAME>`
- Update the `#subscribed` method with a stream option.
  - In the current example, we're streaming FOR a given user. You can replace this with any object. Alternatively, you can stream FROM a given string. For the difference between `stream_for` and `stream_from`, [check this asnwer](https://stackoverflow.com/questions/39002150/what-is-the-difference-between-stream-from-and-stream-for-in-actioncable). Ideally, you want to use `stream_for` since you want to rely on domain objects and not on strings.

### 4. [Create a Client side channel file - my_channel.js](https://github.com/caioertai/action-cable-demo/commit/a87aa4d071ca2d80584a89f6e7fbaf4b8eed1848)
- Create a consumer `app/javascript/channels/consumer.js` [following the example](https://github.com/caioertai/action-cable-demo/commit/a87aa4d071ca2d80584a89f6e7fbaf4b8eed1848#diff-30a69433d2c6c09d378710becb60d2de)
  - You want this on a separate file so it can be used by multiple channels.
- Create the client-side channel `app/javascript/channels/my_channel.js`. Read the [change log on the file](https://github.com/caioertai/action-cable-demo/commit/a87aa4d071ca2d80584a89f6e7fbaf4b8eed1848#diff-2e6ec126c0372a81d04053af6e862486) for more info.
  - You might want to have your `received` callback like this for later testing:
    ```javascript
    received: (data) => {
      alert(data)
    }
    ```
    That's what's going to be executed when a new broadcast is received by the client.
- Call your channel subscription on your `application.js`. You can [use this](https://github.com/caioertai/action-cable-demo/commit/a87aa4d071ca2d80584a89f6e7fbaf4b8eed1848#diff-c0a98e77a42efd669302853444d5c362) as an example.
  - Very rarely you'll want this call to be made in every page as it's done in here. Think about what you're creating and tailor it to your needs. If it's a chat room, it should only be called when the chat component is initialized. Etc...

### 5. Using channels and broadcasts
At this point the setup is done. If you're using the same example as the DEMO (check the latest 2 commits) you're subscribing to the currently logged in user everytime (meaning every user will be subscribed to their own channel). A subscribed browser session should then be able to receive broadcasts from their subscribed channels, given they are streaming from the same object.

Broadcasting is done by calling (you can do this from `rails c`):
```ruby
# Assuming @user is assigned to an user instance
MyChannel.broadcast_to(@user, "Here's a message!")

# You can, and most likely will, also send hashes or arrays
MyChannel.broadcast_to(@user, { type: "alert", message: "Here's a message!" }) # Curly braces for clarity. Avoid them.
```

This will trigger the `received` callback on your [client-side file](https://github.com/caioertai/action-cable-demo/commit/a87aa4d071ca2d80584a89f6e7fbaf4b8eed1848#diff-2e6ec126c0372a81d04053af6e862486).

## Last Words
This is a quick demo designed to showcase ActionCable to Le Wagon students and hopefully inspire you to use it in your projects. It's more practical than abstract.

If you have any questions or suggestions for improvements feel free to open an issue or contact me on Le Wagon slack `@caioertai or Caio Andrade`

## Additional Resources

### Action Cable Official guide
https://guides.rubyonrails.org/action_cable_overview.html
