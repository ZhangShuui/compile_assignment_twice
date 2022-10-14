.PHONY:test,clean
test:
	arm-linux-gnueabihf-gcc compile_test.s -o compile_test
	qemu-arm -L /usr/arm-linux-gnueabihf/ ./compile_test
clean:
	rm -fr gcctest