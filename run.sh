#!/bin/bash

# ==============================================================
# etErp 관리 쉘 스크립트
# 사용법: ./run.sh [start|stop|restart|build|rebuild|log|status]
# ==============================================================

APP_NAME="etErp"
JAR_FILE="build/libs/etErp-0.0.1-SNAPSHOT.jar"
LOG_FILE="application.log"
PID_FILE="application.pid"

# 기능: 애플리케이션 빌드
function build() {
    echo "======================================"
    echo "[$APP_NAME] 빌드를 시작합니다 (테스트 제외)..."
    echo "======================================"
    ./gradlew clean build -x test
    
    if [ $? -eq 0 ]; then
        echo "[$APP_NAME] 빌드가 성공적으로 완료되었습니다."
    else
        echo "[$APP_NAME] 빌드 실패! 로그를 확인해주세요."
        exit 1
    fi
}

# 기능: 애플리케이션 시작
function start() {
    if [ -f $PID_FILE ]; then
        echo "[$APP_NAME] 이미 해당 애플리케이션이 실행 중입니다. (PID: $(cat $PID_FILE))"
        return
    fi

    if [ ! -f $JAR_FILE ]; then
        echo "[$APP_NAME] JAR 파일을 찾을 수 없습니다. 먼저 build를 실행해주세요."
        echo "명령어: ./run.sh build"
        return
    fi
    
    echo "======================================"
    echo "[$APP_NAME] 백그라운드에서 애플리케이션 시작..."
    echo "======================================"
    
    nohup java -jar $JAR_FILE > $LOG_FILE 2>&1 &
    PID=$!
    echo $PID > $PID_FILE
    
    echo "[$APP_NAME] 실행 완료 (PID: $PID)"
    echo "[$APP_NAME] 로그 확인: ./run.sh log 또는 tail -f $LOG_FILE"
}

# 기능: 애플리케이션 중지
function stop() {
    if [ ! -f $PID_FILE ]; then
        echo "[$APP_NAME] 실행 중인 애플리케이션을 찾을 수 없습니다. ($PID_FILE 없음)"
        
        # 간혹 PID 파일만 없고 포트는 살아있을 수 있으므로 직접 찾기
        PID=$(pgrep -f "etErp-0.0.1-SNAPSHOT.jar")
        if [ -n "$PID" ]; then
            echo "[$APP_NAME] 남겨진 프로세스 발견 (PID: $PID). 강제 종료합니다."
            kill -9 $PID
        fi
        return
    fi

    PID=$(cat $PID_FILE)
    echo "======================================"
    echo "[$APP_NAME] 애플리케이션 종료 중 (PID: $PID)..."
    echo "======================================"
    
    kill -15 $PID
    sleep 3
    
    # 종료 안됐으면 강제종료
    if ps -p $PID > /dev/null; then
        echo "[$APP_NAME] 프로세스가 종료되지 않아 강제 종료(kill -9) 합니다."
        kill -9 $PID
    fi
    
    rm -f $PID_FILE
    echo "[$APP_NAME] 프로세스가 완전히 종료되었습니다."
}

# 기능: 상태 확인
function status() {
    if [ -f $PID_FILE ]; then
        PID=$(cat $PID_FILE)
        if ps -p $PID > /dev/null; then
            echo "[$APP_NAME] 정상적으로 실행 중입니다. (PID: $PID)"
        else
            echo "[$APP_NAME] 비정상 종료됨. $PID_FILE 파일이 남아있었으나 프로세스가 없습니다."
            rm -f $PID_FILE
        fi
    else
        echo "[$APP_NAME] 실행 중이지 않습니다."
    fi
}

# 기능: 실시간 로그 확인
function log() {
    if [ -f $LOG_FILE ]; then
        tail -f $LOG_FILE
    else
        echo "[$APP_NAME] 로그 파일($LOG_FILE)이 아직 존재하지 않습니다."
    fi
}

# 기능: 완전 재빌드 후 재실행 (소스 pull 포함)
function rebuild() {
    echo "======================================"
    echo "[$APP_NAME] Git Pull 및 전체 Re-Build, 재실행을 시작합니다."
    echo "======================================"
    stop
    echo "[$APP_NAME] Git 소스 최신화 (git pull origin main)..."
    git pull origin main
    build
    start
}


# ==============================================================
# 명령줄 인수 분기
# ==============================================================
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        sleep 2
        start
        ;;
    build)
        build
        ;;
    rebuild)
        rebuild
        ;;
    status)
        status
        ;;
    log)
        log
        ;;
    *)
        echo "Usage: ./run.sh {start|stop|restart|build|rebuild|status|log}"
        echo "  start    : 어플리케이션 백그라운드 실행"
        echo "  stop     : 어플리케이션 종료"
        echo "  restart  : 어플리케이션 재시작"
        echo "  build    : gradle 빌드 (.jar 갱신)"
        echo "  rebuild  : 스탑 -> git pull -> 빌드 -> 실행 (전체 갱신)"
        echo "  status   : 현재 실행 상태 확인"
        echo "  log      : 실시간 애플리케이션 로그 보기"
        exit 1
esac
exit 0
