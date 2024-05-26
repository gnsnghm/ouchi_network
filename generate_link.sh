#!/bin/bash
#
#       generate_links.sh
#

output_file="links.md"
TITLE="# 各種リンク"

echo "" > ${output_file}

# フォルダ名一覧を取得し、whileループで処理
find . -mindepth 1 -maxdepth 1 -type d | grep -v '/\.' | grep -v '^\./\.' | while read -r dir; do
    # フォルダ名を取得し、Markdownの見出しとして出力
    folder_name=$(basename "$dir")
    echo "## $folder_name" >> $output_file

    # フォルダ内の全ての .md ファイルを探索
    find "$dir" -type f -name "*.md" | while read -r file; do
        # ファイルの1行目を取得し、リンクのタイトルとする
        title=$(head -n 1 "$file" | sed 's/^# *//')
        # ファイルへの相対パスを取得し、リンクを作成
        relative_path="${file#./}"
        echo "[$title]($relative_path)" >> $output_file
        echo "" >> $output_file
    done

    # 空行を追加
    echo "" >> $output_file
done