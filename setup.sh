#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${RALPM_TMP_DIR}" ]]; then
    echo "RALPM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_INSTALL_DIR}" ]]; then
    echo "RALPM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_BIN_DIR}" ]]; then
    echo "RALPM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/RAL0S/gnuradio/releases/download/v3.10.3.0/gnuradio-3.10.3.0.tar.gz -O $RALPM_TMP_DIR/gnuradio-3.10.3.0.tar.gz
  tar xf $RALPM_TMP_DIR/gnuradio-3.10.3.0.tar.gz -C $RALPM_PKG_INSTALL_DIR/
  rm $RALPM_TMP_DIR/gnuradio-3.10.3.0.tar.gz
  PATH=$RALPM_PKG_INSTALL_DIR/bin/:$PATH conda-unpack
  echo "#!/usr/bin/env bash" > $RALPM_PKG_BIN_DIR/gnuradio-companion
  echo "source $RALPM_PKG_INSTALL_DIR/bin/activate" >> $RALPM_PKG_BIN_DIR/gnuradio-companion
  echo "exec gnuradio-companion" >> $RALPM_PKG_BIN_DIR/gnuradio-companion
  chmod +x $RALPM_PKG_BIN_DIR/gnuradio-companion
}

uninstall() {
  rm -rf $RALPM_PKG_INSTALL_DIR/*
  rm $RALPM_PKG_BIN_DIR/gnuradio-companion
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1