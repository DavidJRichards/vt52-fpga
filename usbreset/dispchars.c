#include <stdio.h>
#include <string.h>

int main(void)
{
   int i,j,k,n;
   char s[8];
   k=0;
   
   printf("\n\r   ");
   for(n=0;n<16;n++)
      printf("%4X",n);
      
   printf("\n\r     ");
   for(n=0;n<16;n++)
      printf("%s","----");
      
   for(i=0;i<16;i++)
   {
      printf("\n\r%3X |",k);
//      printf("\n\r|");
      for (j=0;j<16;j++)
      {
         switch(k){
         case 7:
            strcpy(s,"tab");
            break;
         
         case 8:
            strcpy(s,"bs ");
            break;
         
         case 10:
            strcpy(s,"nl ");
            break;
            
         case 27:
           strcpy(s,"esc");
            break;

         case 127:
            strcpy(s,"del");
            break;
            
         case 13:
            strcpy(s,"cr ");
            break;

         case 9:
         case 12:
         case 11:
         case 15:
         case 26:
//            sprintf(s,"\\x%2.2X",k);
            *s=0;
            break;
         
         case 0:
         case 1:
         case 2:
         case 3:
         case 4:
         case 5:
         case 6:
         case 14:
         case 16:
         case 17:
         case 18:
         case 19:
         case 20:
         case 21:
         case 22:
         case 23:
         case 24:
         case 25:
         case 28:
         case 29:
         case 30:
         case 31:
//            sprintf(s,"\\x%2.2X",k);
            *s=0;
         break;
         
         default:       
            sprintf(s,"%c ",k);
            break;
         } /* end case */
         printf("%3.3s",s);
         k++;
         printf("|");
      } /* end j */
//      printf("\n\r  ");
//      for(n=0;n<16;n++)
//         printf("%s","----");
   } /* end i */
   printf("\n\r     ");
   for(n=0;n<16;n++)
      printf("%s","----");
   printf("\n\r   ");
   return 0;
}
