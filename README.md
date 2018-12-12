# docker-ethos-xmr-stak
Based off of docker-ethos-ethminer originally by trick77 https://github.com/trick77/docker-ethos-ethminer

Docker image which makes building your own or preferred version of xmr-stak for ethOS super easy without polluting your system with openCL and CUDA libraries. The resulting binary can be used to replace the existing xmr-stak binary and .so files in /opt/miners/xmr-stak of your mining rig. Make sure to backup the existing binary though. Please be  aware that the new binary may get replaced with every manual update of ethOS and/or its miners. 

Build the image with ```docker build -t xmr-stak .```

Building the image will take quite some time and download more than 1 GB of data. Build errors have to be fixed but shouldn't occur unless one of the referenced libraries (i.e. the CUDA toolkit) changes its name/availability.
Once the image build was successful and the container was created using the command, the binaries can be copied from the container to the host with a simple ```docker run -v $(pwd):/host -it xmr-stak```.

To rebuild with an updated code base without having to delete all images and start fresh (within the same cuda version / opencl version) just run the second command again.

note: .a files in build directory are not needed. only the *.so files and xmr-stak binary
