# Project Setup Instructions

Welcome to the Time Manager project. Follow these steps to get your development environment up and running.

## Cloning the Repository

First, you need to clone the repository:

```bash
git clone https://github.com/simlf/TimeManager.git
cd TimeManager
```

## Environment Configuration

Before running the application, you need to set up the environment variables:

1. Navigate to the `/doc` directory.
2. Take a look at the `.env.template` file which contains a sample configuration.
3. Create a new `.env` file by copying the `.env.template` file:

   ```bash
   cp doc/.env.template .env
```

4. Edit the .env file with your specific configurations.

## Building with Docker

- Ensure you have Docker and Docker Compose installed on your machine. Then, build and start the services:

```bash
docker-compose up --build
```
## Accessing the Application

- After the Docker containers are up and running, open your web browser and navigate to the URL specified in your .env file's CORS_ORIGIN value.


### Enjoy your time with the Time Manager application!


