assert_success(){
    if [ "$1" != "0" ]; then
      echo "Error [$2]!"
      exit 3
    fi
}