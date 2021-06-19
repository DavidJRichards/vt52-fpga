#include <stdio.h>
#include <string.h>

int main(void)
{
   int i,j,k,n;
   char s[8];
   k=0;

//   printf("\x1b%c",'F');
   
   printf("\n\n\n\n\n\n\n\n\r   ");
   for(n=0;n<16;n++)
      printf("%4X",n);
      
   printf("\n\r    \xda");
   for(n=0;n<15;n++)
      printf("%s","\xc4\xc4\xc4\xc2");
   printf("%s","\xc4\xc4\xc4\xbf");
      
   for(i=0;i<16;i++)
   {
      printf("\n\r%3X \xb3",k);
      for (j=0;j<16;j++)
      {
         switch(k){
         case 7:
            strcpy(s,"bel");
            break;
         
         case 8:
            strcpy(s," bs");
            break;
         
         case 9:
            strcpy(s,"tab");
            break;
         
         case 10:
            strcpy(s," lf");
            break;
            
         case 27:
           strcpy(s,"esc");
            break;

         case 127:
            strcpy(s,"del");
            break;
            
         case 13:
            strcpy(s," cr");
            break;

         case 12:
            strcpy(s," ff");
            break;

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
         if( (k>=96) && (k<127) )
            printf("\x1b%c",'F');
            
         printf("%3.3s",s);
         printf("\x1b%c",'G');
         k++;
         printf("\xb3");
      } /* end j */
      
      if(i==15)continue;
      
      if(i==7)
      {
         printf("\n\r    \xc0");
         for(n=0;n<15;n++)
            printf("%s","\xc4\xc4\xc4\xc1");
         printf("\xc4\xc4\xc4\xd9\n\r   ");
         getchar();
         printf("\n\n\n\n\n\n\n\n\r    \xda");
         for(n=0;n<15;n++)
            printf("%s","\xc4\xc4\xc4\xc2");
         printf("%s","\xc4\xc4\xc4\xbf");
      }
      else
      {
         printf("\n\r    \xc3");
         for(n=0;n<15;n++)
            printf("%s","\xc4\xc4\xc4\xc5");
         printf("%s","\xc4\xc4\xc4\xb4");
      }   
   } /* end i */
   printf("\n\r    \xc0");
   for(n=0;n<15;n++)
      printf("%s","\xc4\xc4\xc4\xc1");
   printf("\xc4\xc4\xc4\xd9\n\r   ");
   printf("\x1b%c",'G');
   getchar();
   return 0;
}
