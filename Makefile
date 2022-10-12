.PHONY:test,clean
test:
	arm-linux-gnueabihf-gcc compile_test2.s -o compiletest2
	qemu-arm -L /usr/arm-linux-gnueabihf/ ./compile_test2
clean:
	rm -fr gcctest