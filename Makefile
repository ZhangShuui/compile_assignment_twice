.PHONY:test,clean
test:
	arm-linux-gnueabihf-gcc gcc_test.s -o gcctest
	qemu-arm -L /usr/arm-linux-gnueabihf/ ./gcctest
clean:
	rm -fr gcctest