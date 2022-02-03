for file in ./unpatched/*.ttf; do
    fontforge -script ../.fontpatcher/font-patcher.py "$file" --complete
done
