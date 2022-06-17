update-schemaspy:
	java -jar ~/.local/bin/schemaspy-6.1.0.jar -t pgsql -db td_main -o ~/tmp -u ro_user -host localhost -port 5432 -dp ~/.local/bin/drivers -loadjars -debug -p ro_user

serve-schemaspy:
	cd ~/tmp && microserver --port 8000 > /dev/null 2>&1