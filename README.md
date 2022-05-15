# arrays_merge_ip_soc
A soc where a microblaze processor has 2 arrays needs to be merged and sorted.
https://www.faceprep.in/c/merge-two-sorted-arrays-program-in-c-c-java-and-python/
The microblaze sends the arrays, through an AXI4 interface, to an IP, where the merging and sorting happens, utilizing 3 FIFOs, then the IP sends the resulting merged array to the microblaze. The result is printed in the TCL console. The AXI4 interface between the microblaze and the IP has 5 registers used as follows:
        1- Register with addr 0x0 is used by the microblaze to start the IP.
        2- Register with addr 0x4 is as a status register.
        3- Register with addr 0x8 is used by the microblaze to request reading the results from the IP.
        4- Register with addr 0xC is used to write the first arrays to the IP.
        5- Register with addr 0x10 is used to write the second arrays to the IP.
