alias w := watch
alias sea := start-ext-api
alias lpr := list-prs
alias lghi := list-issues

update-schemaspy:
	java -jar ~/.local/bin/schemaspy-6.2.4.jar -t pgsql -db td_main -o ~/tmp -u ro_user -host localhost -port 5432 -dp ~/.local/bin/drivers -loadjars -debug -p ro_user --image-format svg --no-implied 

serve-schemaspy:
	cd ~/tmp && microserver --port 8000 > /dev/null 2>&1

watch test-name='':
	watchexec --on-busy-update restart --debounce 3000 -c -e rs -- cargo nextest run --tests -j 1 {{test-name}}

update-fish-config:
	meld private_dot_config/private_fish/config.fish.tmpl ~/.config/fish/config.fish

start-ext-api:
	~/.local/bin/copy-ext-api-creds-to-clipboard.sh
	cargo run ext-api run http://127.0.0.1:8002

list-prs:
	@tea pr ls -o tsv -f index,mergeable,title,assignees | tsv-filter --H --str-in-fld 4:Bas | tsv-select -f1,2,3

list-issues:
	@tea issue -f index,title,assignees -o tsv | tsv-filter --H --str-in-fld 3:Bas  | tsv-select -f1,2

top-migration:
	cd ~/ds/code/td && fd --glob -p '**/migrations/V*.sql' -x /usr/bin/echo {/.} | sort -nr | head
validate-api-spec spec-name='admin':
	cargo xtask api-docs prepare --yaml
	go run github.com/daveshanley/vacuum@latest lint apidocs/specs/{{spec-name}}/www/openapi.yaml  --errors -d -s
