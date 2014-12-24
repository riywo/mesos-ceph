scripts = scripts/*.sh

all: build commit

build: ami.tf

commit: build
	git add ami.tf
	git commit -m "Packer build $(date)"

clean:
	rm -f ami.tf

ami.tf: base.json $(scripts)
	packer build -machine-readable $< | ./process $@
