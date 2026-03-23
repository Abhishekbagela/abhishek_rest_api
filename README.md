# Abhishek Rest API (Vapor + MySQL + Docker) 🚀

![Vapor Version](https://img.shields.io/badge/Vapor-4.0+-brightgreen.svg)
![Swift Version](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![Docker Ready](https://img.shields.io/badge/Docker-Ready-blue.svg)
![HTTPS Secured](https://img.shields.io/badge/HTTPS-mkcert-blueviolet.svg)

A professional, fully-featured REST API built with the **Vapor** web framework. This project demonstrates high-performance database management, automated external data synchronization, and a secure local development environment with HTTPS.

---

## ✨ Key Features

- **Full CRUD API**: Robust endpoints for managing Movies, Users, and Images with integrated **Pagination** support (`?page=1&per=10`).
- **500-Movie Sync**: Connects to an external API and performs high-speed, multi-page synchronization of 500 movies into MySQL, with built-in data-loss protection for incomplete records.
- **Standardized Responses**: All list endpoints return a consistent JSON structure with items and pagination metadata (`total`, `page`, `per`).
- **Dockerized Architecture**: Simplified deployment with pre-configured `docker-compose.yml`.
- **Safari-Trusted HTTPS**: Integrated SSL support via `mkcert` for a standard, secure browsing experience (`https://localhost`).
- **Interactive Documentation**: Full **Swagger UI** integration for visual API testing.
- **Server Lifecycle Management**: API-driven control to check health, stop, or restart the server.

---

## 🛠 Prerequisites

Ensure you have the following installed:
- [Docker & Docker Compose](https://docs.docker.com/get-docker/)
- [mkcert](https://github.com/FiloSottile/mkcert) (for local HTTPS trust)

---

## 🚀 Quick Start & Installation

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/abhishek_rest_api.git
cd abhishek_rest_api
```

### 2. Setup Trusted Local SSL
Run the following to generate valid certificates that your browser will trust:
```bash
mkcert -install
mkcert -cert-file cert.pem -key-file key.pem localhost 127.0.0.1 ::1
```

### 3. Start the Server
Use the included management script to build and launch the environment:
```bash
chmod +x manage.sh
./manage.sh start
```

---

## 📖 API Usage & Documentation

Once the server is running, explore the following:

- **Welcome Page**: [https://localhost:8080/](https://localhost:8080/)
- **Interactive Swagger UI**: [https://localhost:8080/swagger](https://localhost:8080/swagger)
- **Database Status**: [https://localhost:8080/lifecycle/status](https://localhost:8080/lifecycle/status)

### Core Endpoints:
| Feature | Endpoint | Method(s) |
| :--- | :--- | :--- |
| **Movies** | `/movies` | `GET`, `POST` |
| | `/movies/:id` | `GET`, `PUT`, `DELETE` |
| | `/movies/sync` | `POST` |
| **Users** | `/users` | `GET`, `POST` |
| | `/users/:id` | `GET`, `PUT`, `DELETE` |
| **Images** | `/images` | `GET`, `POST` |
| | `/images/:id` | `GET`, `PUT`, `DELETE` |
| **System** | `/lifecycle/status` | `GET` |
| | `/lifecycle/restart` | `POST` |

---

## 📄 Pagination Support

All list endpoints (`/movies`, `/users`, `/images`) support pagination via query parameters:

- `page`: The page number (default: 1)
- `per`: Number of items per page (default: 10, max: 100)

**Example Request:**
`GET https://localhost:8080/movies?page=1&per=5`

**Example Response:**
```json
{
  "items": [...],
  "metadata": {
    "total": 500,
    "per": 5,
    "page": 1
  }
}
```

---

## 🛡 Security Note (CRITICAL)

The following files are **intentionally excluded** from this repository via `.gitignore` to prevent leaking local credentials and secrets:
- `cert.pem` & `key.pem` : These are unique to your local machine (`mkcert`).
- `.env` : Contains database passwords and configuration.

**How to configure for production:**
1. Rename `.env.example` to `.env`.
2. Update the credentials in the `.env` file.
3. Replace the `mkcert` certificates with official CA-signed certificates.

---

## 🤝 Contribution & License
Feel free to fork, open issues, and submit PRs! This project is open-source.

*Built with ❤️ using Vapor and Swift.*
