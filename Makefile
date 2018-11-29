all: presentation.pdf

presentation.pdf: presentation.md
	pandoc -o $@ $^

run:
	patat presentation.md
