#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ADDR_NUM 256

void ReadData(char* pRFilePath,char* pWFilePath)
{
  FILE *rfp,*wfp;
  int data = 0;
  int addr = 0;
  int data_num = 0;

  int blk_data[ADDR_NUM][15] = {0};
  int cnt_data[ADDR_NUM] = {0};

  if((rfp = fopen(pRFilePath,"r")) == NULL){
    printf("fail to read");
    exit (1) ;
  }
  if((wfp = fopen(pWFilePath,"w+")) == NULL){
    printf("fail to write");
    exit (1) ;
  }
  while( !feof(rfp)){
    fscanf(rfp,"%3d:%3d ",&data,&addr);

    blk_data[addr][cnt_data[addr]] = data;

    if( cnt_data[addr] == 14 ){
      cnt_data[addr] = 0;
      fprintf( wfp, "%3d ", addr);
      for( int i =0; i< 15; i++ ){
        fprintf( wfp, "%3d ", blk_data[addr][i]);
        blk_data[addr][i] = 0;
      }
      fprintf( wfp, "\n");
    }else{
      cnt_data[addr]++;
    }

    data_num++;
  }

  for(int i =0; i< ADDR_NUM; i++ ){
    if( cnt_data[i] >0 ){
      fprintf( wfp, "%3d ", i);
      for( int j =0; j< 15; j++ ){
        fprintf( wfp, "%3d ", blk_data[i][j]);
      }
      fprintf( wfp, "\n");
    }
  }

  fclose(rfp);
  fclose(wfp);
  return ;
}

void ReadFlag(char* pRFilePath,char* pWFilePath)
{
  FILE *rfp,*wfp;
  char flag[4][9];
  int flag_num = 0;

  if((rfp = fopen(pRFilePath,"r")) == NULL){
    printf("fail to read");
    exit (1) ;
  }
  if((wfp = fopen(pWFilePath,"w+")) == NULL){
    printf("fail to write");
    exit (1) ;
  }
  while( !feof(rfp)){
    fscanf(rfp,"%8s %8s %8s %8s ",flag[0],flag[1],flag[2],flag[3]);
    flag_num = flag_num+4;
    fprintf( wfp, "%8s%8s%8s%8s\n", flag[3],flag[2],flag[1],flag[0]);
    for( int i =0; i< 4; i++ ){
      strcpy(flag[i],"00000000");
    }
  }

  fclose(rfp);
  fclose(wfp);
  return ;
}

int main()
{
  //read data
  ReadData("data.txt","./dump/data_c.txt");
  ReadFlag("flag.txt","./dump/flag_c.txt");
  //getchar();

  return 0;
}
