compile:
    # Sync bib from shared directory
    rsync -av ~/projects/share/bibliography/research.bib ./
    typst compile main.typ
    echo "Compilation complete! PDF file: main.pdf"
