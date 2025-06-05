#!/bin/bash
# Archivo: poppler_cmd.sh
# Descripción: Script para gestionar el repositorio poppler-0.68.0 y comandos asociados
# Extensión del archivo: .sh
REPO_URL="https://github.com/DH4K3R/poppler-0.68.0.git"
REPO_DIR="poppler-0.68.0"
# Si el usuario ejecuta 'pip install poppler-utils1', mostrar advertencia y sugerir uso del script
if [[ "$0" == *"pip"* ]] || [[ "$1" == "pip" ]]; then
    echo "Este repositorio no es compatible con 'pip install poppler-utils1'."
    echo "Por favor, use este script con: ./poppler_cmd.sh {clone|install|build}"
    exit 1
fi
function clone_repo() {
    if [ -d "$REPO_DIR" ]; then
        echo "El repositorio ya existe en $REPO_DIR"
    elif [ -f "poppler-0.68.0.tar.gz" ]; then
        echo "Descomprimiendo archivo poppler-0.68.0.tar.gz..."
        tar -xzf poppler-0.68.0.tar.gz
        echo "El repositorio se ha descomprimido en $REPO_DIR"
        # Si es en Windows, mover a "C:\Program Files" (requiere privilegios de administrador)
        if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
            echo "Moviendo $REPO_DIR a 'C:\\Program Files'..."
            mv "$REPO_DIR" "/c/Program Files/"
            echo "Repositorio movido a 'C:\\Program Files\\$REPO_DIR'"
        fi
    else
        git clone "$REPO_URL"
    fi
    else
        git clone "$REPO_URL"
    fi
}

function install_dependencies() {
    sudo apt update
    sudo apt install -y cmake g++ pkg-config qt5-default libfontconfig1-dev libjpeg-dev libopenjpeg-dev libpng-dev libtiff-dev libcurl4-openssl-dev
}

function build_repo() {
    cd "$REPO_DIR" || exit 1
    mkdir -p build && cd build
    cmake ..
    make -j$(nproc)
}

function usage() {
    echo "Uso: $0 {clone|install|build}"
    echo "  clone   - Clona el repositorio poppler-0.68.0"
    echo "  install - Instala las dependencias necesarias"
    echo "  build   - Compila el repositorio"
}

case "$1" in
    clone)
        clone_repo
        ;;
    install)
        install_dependencies
        ;;
    build)
        build_repo
        ;;
    *)
        usage
        ;;
esac