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

1. Take a look at the `.env.template` file in the `doc/` directory which contains a sample configuration. Review the file to understand the required environment variables.

Note: CORS_ORIGIN should be the URL where the frontend application will run, and this value is used by the backend to handle cross-origin requests.

2. Create a new `.env` file by copying the `.env.template` file:

```bash
   cp doc/.env.template .env
```

3. Edit the .env file with your specific configurations, paying special attention to the CORS_ORIGIN as it pertains to the backend's CORS settings.

## Building with Docker

- Ensure you have Docker and Docker Compose installed on your machine. Then, build and start the services:

```bash
docker-compose up --build
```

## Accessing the Application

- After the Docker containers are up and running, open your web browser and navigate to the URL specified in your `.env` file's `CORS_ORIGIN` value, for example :
```bash
 http://localhost:5173
```

### Enjoy your time with the Time Manager application!
