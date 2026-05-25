#!/bin/bash

# =========================
# KHAI BÁO BIẾN
# =========================

PROJECT_DIR="$HOME/student_backup_system"
DATA_DIR="$PROJECT_DIR/data"
BACKUP_DIR="$PROJECT_DIR/backups"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/backup.log"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="data_backup_$DATE.tar.gz"

# =========================
# MÀU TERMINAL
# =========================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# =========================
# KIỂM TRA INTERNET
# =========================

check_internet() {
    ping -c 1 google.com &> /dev/null

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Internet Connected${NC}"
    else
        echo -e "${RED}No Internet Connection${NC}"
    fi
}

# =========================
# BACKUP DỮ LIỆU
# =========================

backup_data() {

    mkdir -p "$BACKUP_DIR"
    mkdir -p "$LOG_DIR"

    tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$DATA_DIR"

    echo "[$(date)] Backup created: $BACKUP_FILE" >> "$LOG_FILE"

    echo -e "${GREEN}Backup completed successfully${NC}"

    # Chỉ giữ lại 5 file backup mới nhất
    ls -tp "$BACKUP_DIR" | grep '.tar.gz' | tail -n +6 | xargs -I {} rm -- "$BACKUP_DIR/{}"
}

# =========================
# XEM DANH SÁCH BACKUP
# =========================

view_backups() {
    echo -e "${YELLOW}List of backups:${NC}"
    ls -lh "$BACKUP_DIR"
}

# =========================
# XEM LOG
# =========================

view_logs() {
    echo -e "${YELLOW}Backup Logs:${NC}"
    cat "$LOG_FILE"
}

# =========================
# MENU
# =========================

while true
do
    echo "=============================="
    echo " STUDENT BACKUP SYSTEM "
    echo "=============================="
    echo "1. Backup dữ liệu"
    echo "2. Xem danh sách backup"
    echo "3. Xem log"
    echo "4. Kiểm tra Internet"
    echo "5. Thoát"
    echo "=============================="

    read -p "Chọn chức năng: " choice

    case $choice in
        1)
            backup_data
            ;;
        2)
            view_backups
            ;;
        3)
            view_logs
            ;;
        4)
            check_internet
            ;;
        5)
            echo "Thoát chương trình..."
            exit 0
            ;;
        *)
            echo -e "${RED}Lựa chọn không hợp lệ${NC}"
            ;;
    esac
done
