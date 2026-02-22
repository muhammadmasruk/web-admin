#!/bin/bash

# 1. Clone Flutter SDK versi stable (shallow clone agar cepat)
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# 2. Masukkan Flutter ke PATH sementara untuk sesi build ini
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Jalankan pembersihan dan build
flutter doctor
flutter build web --release