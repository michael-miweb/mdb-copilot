#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "========================================="
echo "  MDB Copilot - Quality Check"
echo "========================================="

# Backend
echo ""
echo "📦 Backend (Laravel)"
echo "---"

echo "🔍 PHPStan (analyse statique)..."
cd "$ROOT_DIR/backend-api"
./vendor/bin/phpstan analyse --no-progress --memory-limit=512M

echo "🎨 Laravel Pint (formatage)..."
./vendor/bin/pint --test

echo "🧪 PHPUnit (tests)..."
php artisan test

# Frontend
echo ""
echo "📱 Frontend (Flutter)"
echo "---"

echo "🔍 Flutter analyze..."
cd "$ROOT_DIR/mobile-app"
flutter analyze

echo "🧪 Flutter test..."
flutter test

echo ""
echo "========================================="
echo "✅ Quality check complet — tout est OK !"
echo "========================================="
