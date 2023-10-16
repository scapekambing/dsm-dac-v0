#include <stdio.h>
#include <math.h>

#define TABLE_SIZE     50
#define SCALE         16384
#define LINE_VALUES       1

int data[TABLE_SIZE];

int main(int argc, char *argv[]) {
   int i;

   for(i = 0; i < TABLE_SIZE; i++) {
      double angle = (i*2+1.0)/(TABLE_SIZE*2);
      double s = sin(angle*M_PI*2.0);
      data[i] = round(SCALE*s); // round up
   }

   for(i = 0; i < TABLE_SIZE; i++) {
     if(i%LINE_VALUES == 0) 
        printf("       ");

     printf("sine[%i]   =   %6i;", i, data[i]);

     if(i == TABLE_SIZE-1) {
        printf("\n");
     } else if((i%LINE_VALUES) == LINE_VALUES-1) {
        printf("\n");
     } else {
        printf(" ");
     }
   }
}