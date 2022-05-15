#include "xparameters.h"
#include "xio.h"

int main()
{
	u32 a[]={1,5,6,9,16,25,32};

	u32 b[]={3,5,7,10,12,20};
	u32 c[13];
	for(int i=0;i<7;i++)
	{
		XIo_Out32(XPAR_MEGE_IP_V1_0_0_BASEADDR+0xc,a[i]);
	}
	for(int i=0;i<6;i++)
	{
		XIo_Out32(XPAR_MEGE_IP_V1_0_0_BASEADDR+0x10,b[i]);
	}
	XIo_Out32(XPAR_MEGE_IP_V1_0_0_BASEADDR,0x1);
	u32 status = XIo_In32(XPAR_MEGE_IP_V1_0_0_BASEADDR+0x4);
	while(!status)
		status = XIo_In32(XPAR_MEGE_IP_V1_0_0_BASEADDR+0x4);
	for(int i=0;i<13;i++)
	{
		c[i]=XIo_In32(XPAR_MEGE_IP_V1_0_0_BASEADDR+0x8);
		xil_printf("%d\n",c[i]);
	}

}
