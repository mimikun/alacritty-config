set shell := ["pwsh.exe", "-c"]

today := `Get-Date -Format 'yyyyMMdd'`
product_name := "alacritty-config"
gpg_pub_key := "CCAA9E0638DF9088BB624BC37C0F8AD3FB3938FC"

default:
	just --list

alias pab := patch-branch

#--------------------
#    patch
#--------------------

patch : clean-patch diff-patch copy2win-patch

diff-patch-raw :
	git diff origin/master > {{product_name}}.{{today}}.patch

#diff-patch-gpg :
#	git diff origin/master | gpg --encrypt --recipient {{gpg_pub_key}} > {{product_name}}.{{today}}.patch.gpg

diff-patch : diff-patch-raw

patch-branch :
	git switch -c patch-{{today}}

switch-master :
	git switch master

delete-branch : switch-master
	git branch --list "patch*" | ForEach-Object{ $_ -replace " ", "" } | ForEach-Object { git branch -d $_ }

clean : clean-patch

clean-patch :
	Remove-Item *.patch

copy2win-patch :
	Copy-Item *.patch $env:USERPROFILE\Downloads\

#--------------------
#    development
#--------------------

lint : yaml-lint

yaml-lint :
	echo "TODO"

fmt : format

format : yaml-format

yaml-format :
	echo "TODO"

run : copy2win

copy2win-config :
	Copy-Item ./alacritty.yml $env:APPDATA/alacritty/alacritty.yml
