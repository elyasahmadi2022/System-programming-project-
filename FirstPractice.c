#include<stdio.h>
int main(int argu, char *argv[]){
    if(strcmp(argv[1], "-h") == 0){

        printf("listing all hidden files...");
        printf("\n");
    }
    else if(strcmp(argv[1], "-e") == 0)
    {
        printf("listing all encrypted files..");
        printf("\n");
    }
    return 0;
    
  
}
