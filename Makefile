today   = $(shell date "+%Y%m%d")
product_name = alacritty-config
gpg_pub_key = CCAA9E0638DF9088BB624BC37C0F8AD3FB3938FC

.PHONY : default
default : run

.PHONY : patch
patch : clean diff-patch copy2win-patch

.PHONY : diff-patch-raw
diff-patch-raw :
	git diff origin/master > $(product_name).$(today).patch

.PHONY : diff-patch-gpg
diff-patch-gpg :
	git diff origin/master | gpg --encrypt --recipient $(gpg_pub_key) > $(product_name).$(today).patch.gpg

.PHONY : diff-patch
diff-patch : diff-patch-raw

.PHONY : patch-branch
patch-branch :
	git switch -c patch-$(today)

.PHONY : switch-master
switch-master :
	git switch master

.PHONY : delete-branch
delete-branch : switch-master
	git branch --list "patch*" | xargs -n 1 git branch -D

.PHONY : clean
clean :
	bash utils/clean.sh

.PHONY : copy2win-patch-raw
copy2win-patch-raw :
	cp *.patch $$WIN_HOME/Downloads/

.PHONY : copy2win-patch-gpg
copy2win-patch-gpg :
	cp *.patch.gpg $$WIN_HOME/Downloads/

.PHONY : copy2win-patch
copy2win-patch : copy2win-patch-raw

.PHONY : lint
lint : yaml-lint

.PHONY : yaml-lint
yaml-lint :
	yamllint ./alacritty.yml

.PHONY : fmt
fmt : format

.PHONY : format
format : yaml-format

.PHONY : yaml-format
yaml-format :
	echo "TODO"

.PHONY : copy2win-config
copy2win-config :
	cp ./alacritty.yml $$WIN_HOME/AppData/Roaming/alacritty/alacritty.yml

.PHONY : copy2win
copy2win : copy2win-config

.PHONY : run
run : copy2win
