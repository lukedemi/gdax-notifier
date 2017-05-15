## GDAX Notifier

This app polls GDAX and hits a webhook whenever an order has been filled. I currently use IFTTT Maker to send iOS push notifications.

![Notification Screenshot](/images/notification.jpg?raw=true "What iOS Notifications Look Like")

# Create Maker Webhook

Create an IFTTT account and set up a new maker webhook https://ifttt.com/maker_webhooks and set it up to point at something (like app notifications):

![IFTTT Screenshot](/images/ifttt.png?raw=true "What IFTTT Looks Like")

Set the notification equal to:

```
GDAX {{Value1}} {{Value2}}: {{Value3}}
```

# Build

Create a .env file with:

```
# required
GDAX_API_KEY=
GDAX_API_SECRET=
GDAX_API_PASS=
MAKER_EVENT=
MAKER_KEY=
```

```
docker build -t gdax-notifier .
```

# Run

```
# background
docker run -it -d --restart always --name gdax-notifier --env-file .env gdax-notifier

# foreground
docker run -it --rm --name gdax-notifier --env-file .env gdax-notifier
```
