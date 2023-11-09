# SuperPFM

SuperPFM is a web application that allows users to create connections to a fake bank using the SaltEdge API and manage them. The application enables "Refresh", "Reconnect", and "Delete" actions for each connection. After a connection is refreshed, the "Refresh" button will be temporarily disabled until the connection can be refreshed again. Connections that are being refreshed cannot be deleted or reconnected until the refresh process is completed. SuperPFM also displays accounts and transactions for each connection.

Live version: https://superpfm-production.up.railway.app/

## Features

- Create and manage bank connections via SaltEdge API.
- Perform **Refresh**, **Reconnect**, and **Delete** operations on connections.
- View accounts and transactions associated with each connection.

## Prerequisites

Ensure you have the following installed on your computer for local development:

- Ruby version 3.2.2
- Rails version 7.1.1
- Node.js version 20.9.0
- PostgreSQL 16
- Sidekiq with Redis

Additionally, the application is configured to run inside a development container. Refer to the `.devcontainer/devcontainer.json` file for the container configuration.

## Local Setup

### Installation

1. Clone the repository and navigate into the project directory:
   ```sh
   git clone https://github.com/Sizel/Superpfm.git
   cd superpfm
   ```
   
    Install the required dependencies: `bundle install`

   Prepare the DB: `rails db:prepare`

### Configuring SaltEdge API Access
Obtain your `client_id` and `secret` from SaltEdge by following the [SaltEdge Quick Start Guide](https://docs.saltedge.com/account_information/v5/#quick_start)

Configure your credentials:

1. Remove the existing config/credentials.yml.enc file.
2. Create a new credentials file:
```sh
EDITOR="code --wait" rails credentials:edit  # Replace "code --wait" with your editor command
```
3. Add your credentials in the following format:

```
development:
  se:
    app_id: "your_app_id"
    secret: "your_secret"
```

### Setting Up Callbacks
Set the callbacks for your app on the SaltEdge client dashboard: [SaltEdge Client Callbacks](https://www.saltedge.com/clients/callbacks/edit). Use a tool like [ngrok](https://ngrok.com/) to allow your application to receive external callbacks.


### Running Background Jobs
Ensure Sidekiq and Redis are running to handle background jobs:

```sh
# Start Redis (if not already running as a service)
redis-server

# Start Sidekiq in a separate terminal window
bundle exec sidekiq
```

### Starting the Application
With all configurations in place, start the Rails server: `rails s`

Access the application at **http://localhost:3000** in your browser.
