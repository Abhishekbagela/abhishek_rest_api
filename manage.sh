#!/bin/bash

# Abhishek Rest API Management Script

COMMAND=$1

case $COMMAND in
    start)
        echo "Checking for SSL certificates..."
        if [ ! -f "cert.pem" ] || [ ! -f "key.pem" ]; then
            if command -v mkcert &> /dev/null; then
                echo "Generating trusted certificate via mkcert..."
                mkcert -cert-file cert.pem -key-file key.pem localhost 127.0.0.1 ::1
            else
                echo "Generating self-signed certificate via openssl..."
                openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"
            fi
        fi

        echo "Starting Abhishek Rest API via Docker..."
        docker compose up -d --build
        echo "Waiting for services to be ready..."
        sleep 5
        docker compose logs -f app &
        ;;
    stop)
        echo "Stopping Abhishek Rest API..."
        docker compose down
        ;;
    restart)
        echo "Restarting Abhishek Rest API..."
        docker compose restart
        ;;
    status)
        docker compose ps
        ;;
    logs)
        docker compose logs -f app
        ;;
    clean)
        echo "Cleaning up Docker resources (containers and volumes)..."
        docker compose down -v
        echo "Removing SSL certificates..."
        rm -f cert.pem key.pem
        echo "Done."
        ;;
    *)
        echo "Usage: ./manage.sh {start|stop|restart|status|logs|clean}"
        exit 1
        ;;
esac
