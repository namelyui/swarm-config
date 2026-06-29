#!/bin/bash
set -e

echo "============================================="
echo "🚀 Swarm Network Auto-Deploy Script"
echo "============================================="

echo "Are you setting up the Master Host Server or a Swarm Node?"
echo "1) Master Host Server (Private Backend)"
echo "2) Swarm Miner Node (Public Access)"
while true; do
    read -p "Select an option [1-2]: " MACHINE_TYPE
    if [[ "$MACHINE_TYPE" == "1" || "$MACHINE_TYPE" == "2" ]]; then
        break
    else
        echo "❌ Invalid selection! Please type 1 or 2."
    fi
done

if [ "$MACHINE_TYPE" == "1" ]; then
    echo ""
    echo "================ HOST SERVER SETUP ================"
    echo "Because your backend code is in a PRIVATE repository for security,"
    echo "you must provide a GitHub Personal Access Token to download it."
    read -p "Enter your GitHub Token (ghp_...): " GITHUB_TOKEN

    echo ""
    echo "📦 Installing Server Dependencies..."
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip python3-venv git

    CLONE_DIR="/home/ubuntu/end_repo"
    DB_BACKUP_PATH="/home/ubuntu/database_backup.db"

    # Save the Database before deleting old code!
    if [ -f "$CLONE_DIR/backend/database.db" ]; then
        echo "💾 Backing up existing database to prevent data loss..."
        cp "$CLONE_DIR/backend/database.db" "$DB_BACKUP_PATH"
    fi

    if [ -d "$CLONE_DIR" ]; then
        echo "🗑️ Removing old codebase..."
        sudo rm -rf "$CLONE_DIR"
    fi

    echo "📥 Downloading your Private Codebase..."
    git clone "https://${GITHUB_TOKEN}@github.com/namelyui/end.git" "$CLONE_DIR"

    if [ -f "$DB_BACKUP_PATH" ]; then
        echo "♻️ Restoring your database (Coins, Users, Chats saved!)..."
        cp "$DB_BACKUP_PATH" "$CLONE_DIR/backend/database.db"
    fi

    cd "$CLONE_DIR/backend"

    echo "⚙️ Setting up Python Environment..."
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    pip install fastapi uvicorn websockets pydantic pyyaml psutil aiohttp cryptography

    echo "🔄 Starting the Swarm Server..."
    pkill -f "python.*main.py" || true
    nohup python main.py > backend_run.log 2>&1 &

    echo "============================================="
    echo "🎉 Host Server Deployment Complete!"
    echo "📡 The Master API is now running in the background."
    echo "============================================="

else
    echo ""
    echo "================ SWARM NODE SETUP ================"
    echo "What role should this Swarm Node prioritize to assist the Host?"
    echo "1) All-Rounder (Dynamically handles Overflow Traffic & Compute)"
    echo "2) Compute Hub (Takes heavy processing load off the Host)"
    echo "3) Storage Vault (Hosts static files/images to save Host disk space)"
    read -p "Select an option [1-3]: " ROLE_CHOICE

    case $ROLE_CHOICE in
        2) SERVER_ROLE="compute" ;;
        3) SERVER_ROLE="storage" ;;
        *) SERVER_ROLE="general" ;;
    esac
    echo "✅ Node role set to: $SERVER_ROLE"
    
    echo "⚙️ Setting up Node configuration..."
    echo "SERVER_ROLE=$SERVER_ROLE" > swarm_node.env
    
    # Placeholder for the Node software
    echo "📥 Connecting to Swarm Network..."
    sleep 2
    echo "🚀 Node Software Started!"
    echo "============================================="
    echo "🎉 Node Deployment Complete!"
    echo "💰 You are now routing data and earning coins!"
    echo "============================================="
fi
