#include "apue.h"
#if defined(SOLARIS)
#include <netinet/in.h>
#endif
#include <netdb.h>
#include <arpa/inet.h>
#if defined(BSD)
#include <sys/socket.h>
#include <netinet/in.h>
#endif
void print_flags(struct addrinfo *aip){
	printf("flags");
	if(aip->ai_flags == 0){
		printf("0");
	}else{
		if(aip->ai_flags & AI_PASSIVE){printf("passive");}
		if(aip->ai_flags & AI_CANONNAME){printf("canon");}
		if(aip->ai_flags & AI_NUMERICHOST){printf("numhost");}
		if(aip->ai_flags & AI_NUMERICSERV){printf("numserv");}
		if(aip->ai_flags & AI_V4MAPPED){printf("v4mapped");}
		if(aip->ai_flags & AI_ALL){printf("all");}
	}
}

int main(int argc,char *argv[]){
	struct addrinfo *ailist,*aip;
	struct addrinfo hint;
	int err;
	struct sockaddr_in *sinp;
	const char *addr;
	char abuf[INET_ADDRSTRLEN];
	if(argc != 3) err_quit("usage:%s nodename service",argv[0]);	
	hint.ai_flags=AI_CANONNAME;
	hint.ai_family=0;
	hint.ai_socktype=0;
	hint.ai_protocol=0;
	hint.ai_addrlen=0;
	hint.ai_addr=NULL;
	hint.ai_canonname=NULL;
	hint.ai_next=NULL;
	if(err=getaddrinfo(argv[1],argv[2],&hint,&ailist) != 0) err_quit("getaddrinfo error");	
	for(aip=ailist;aip!=NULL;aip=aip->ai_next){
		print_flags(aip);
		printf("\n\thost %s",aip->ai_canonname?aip->ai_canonname:"-");
		if(aip->ai_family == AF_INET){
			sinp=(struct sockaddr_in *)aip->ai_addr;
			addr=inet_ntop(AF_INET,&sinp->sin_addr,abuf,INET_ADDRSTRLEN);
			printf(" address %s",addr?addr:"unkown");
			printf(" port %d",ntohs(sinp->sin_port));	

		}
		printf("\n");
	}	
	exit(0);
}
