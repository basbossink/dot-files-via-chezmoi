alias w := watch
alias sea := start-ext-api
alias lpr := list-prs

update-schemaspy:
	java -jar ~/.local/bin/schemaspy-6.1.0.jar -t pgsql -db td_main -o ~/tmp -u ro_user -host localhost -port 5432 -dp ~/.local/bin/drivers -loadjars -debug -p ro_user

serve-schemaspy:
	cd ~/tmp && microserver --port 8000 > /dev/null 2>&1

watch test-name='':
	watchexec --on-busy-update restart --debounce 3000 -c -e rs -- cargo nextest run -j 1 {{test-name}}

update-fish-config:
	meld private_dot_config/private_fish/config.fish.tmpl ~/.config/fish/config.fish

start-ext-api:
	~/.local/bin/copy-ext-api-creds-to-clipboard.sh
	cargo run ext-api run http://127.0.0.1:8002

list-prs:
	@gh pr list --author "@me" --json "number","title","reviewRequests"|\
		jq -r '.[]| [.number, .title, .reviewRequests[].login]| @tsv'|\
		tsv-pretty -m 80 |\
		sort -n