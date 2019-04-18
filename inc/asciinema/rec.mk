.PHONY: rec
rec:
	@mkdir ../tmp
	@asciinema rec ../tmp/csv.cast \
 --overwrite \
 --title='grantmacken/csv ran `make up'\
 --idle-time-limit 1 \
 --command='nvim'

.PHONY: rec-example
rec-example:
	@mkdir -p ../tmp
	@clear
	@asciinema rec ../tmp/csv.cast \
 --overwrite \
 --title="grantmacken/csv called 'csv:example()'" \
 --command="\
sleep 1 && printf %60s | tr ' ' '='  && echo && \
echo ' - given this csv file ... ' && \
sleep 1 && printf %60s | tr ' ' '-'  && echo && \
cat unit-tests/fixtures/2018-12.csv && \
sleep 1 && printf %60s | tr ' ' '-'  && echo && \
echo ' - when we provide mapped key-values ..'  && \
sleep 1 && printf %60s | tr ' ' '-'  && echo && \
echo 'map {\"href\" : \"/db/unit-tests/fixtures/2018-12.csv\", ' && \
echo '     \"header-line\": 6,' && \
echo '     \"record-start\": 8,' && \
echo '     \"separator\": \",\"}' && \
sleep 1 && printf %60s | tr ' ' '-'  && echo && \
echo ' - then calling csv:example function results in... ' && \
sleep 1 && printf %60s | tr ' ' '-'  && echo && \
bin/xQcall 'csv:example()' && \
sleep 1 && printf %60s | tr ' ' '-'  && echo && \
sleep 1 && printf %60s | tr ' ' '='  && echo\
"


.PHONY: rec-up
rec-up:
	@asciinema rec tmp/csv.cast \
 --overwrite \
 --title='grantmacken/csv ran `make up'\
 --command='make up'

.PHONY: rec-build
rec-build:
	@clear
	@asciinema rec tmp/csv.cast \
 --overwrite \
 --title='grantmacken/csv ran `make'\
 --command='make'

.PHONY: rec-test
rec-test:
	@clear
	@asciinema rec tmp/csv.cast \
 --overwrite \
 --title='grantmacken/csv ran `make test'\
 --command='make test'

.PHONY: rec-smoke
rec-smoke:
	@clear
	@asciinema rec tmp/csv.cast \
 --overwrite \
 --title='grantmacken/csv ran `make smoke'\
 --command='make smoke'

.PHONY: rec-cov
rec-cov:
	@clear
	@asciinema rec tmp/csv.cast \
 --overwrite \
 --title='grantmacken/csv ran `make coverage'\
 --command='make coverage'

.PHONY: rec-guide
rec-guide:
	@clear
	@asciinema rec tmp/csv.cast \
 --overwrite \
 --title='grantmacken/csv ran `make guide'\
 --command='make guide'

.PHONY: rec-test-all
rec-test-all:
	asciinema rec tmp/csv.cast \
 --overwrite \
 --title='grantmacken/csv run `make test && make smoke && make coverage and make guide`'\
 --command='make test --silent && \
            make smoke --silent && \
            make coverage --silent && \
            make guide --silent'

PHONY: play
play:
	@clear && asciinema play ../tmp/csv.cast

.PHONY: upload
upload:
	asciinema upload ../tmp/csv.cast


