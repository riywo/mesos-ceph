.PHONY: packer clean

all: packer

packer:
	$(MAKE) -C packer

clean:
	$(MAKE) clean -C packer
