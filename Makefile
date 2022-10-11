.PHONY:test,clean
test:
	arm-linux-gnueabihf-gcc gcc_test2.s -o gcctest2
	qemu-arm -L /usr/arm-linux-gnueabihf/ ./gcctest2
clean:
	rm -fr gcctest