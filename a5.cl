__kernel void a5(__global float* data,
      __global float* pattern) {

   float sum;
   float4 input1, input2, sum_vector;
   int global_addr, local_addr;

   int start, end;
   int size = pattern[1];

   local_addr = get_local_id(0);
   int numKernels = pattern[2];
   start = ( local_addr * size ) / numKernels;
   end = ( ( local_addr + 1 ) * size ) / numKernels;

   for(int i = 1; i < size; i++) {
     for(int j = start; j < end; j++) {
        int spot = i*size + j;
        int spotAbove = spot - size;
        int left;
        int right;
        int center = data[spotAbove];
        if(spotAbove-1 == (i-1)*size-1) {
          left = -1;
        }
        else {
          left = data[spotAbove-1];
        }
        if(spotAbove+1 == (i-1)*size+size) {
          right = -1;
        }
        else {
          right = data[spotAbove+1];
        }


        if( left != -1 && !(center != -1 || right != -1) ) {
          data[spot] = local_addr;
        }
        else if( left == -1 && (center != -1 || right != -1) ) {
          data[spot] = local_addr;
        }
     }

     barrier(CLK_LOCAL_MEM_FENCE);

   }



}
