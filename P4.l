%{
#include "y.tab.h"
#include <stdio.h> 
#include <stdlib.h>
#include <math.h>
#include <string.h>
%}

NUM ([0-9]+|\-[0-9]+)
NUMD {NUM}\.{NUM}

SUMA \+
MODULO mod\(
COMA \,
OPP \(
FIN \)
CADENA \"([a-zA-Z0-9 ])+\"|\"\"  

TIPO (int\ |float\ |double\ |char\ )
NOMBRE [a-zA-Z0-9_]+
ASIG \=
FINL \;
MENOR \<
MAYOR \>

COND if\(


%%
{NUM}           {
                printf("Numero entero %s\n",yytext);
                yylval.entero = atoi(yytext);
                return (ENTERO);
                //printf("Numero entero %s\n");
                }

{NUMD}          {
                printf("Numero decimal %s\n",yytext);
                yylval.real=  strtof(yytext,NULL);
                return (FLOTANTE);
                //printf("Numero decimal %s\n");
                }          

{SUMA}          {
                printf("Signo op\n");
                return (SUMA);
                //printf("Signo de operador %s\n");
                }

"*"|"-"|"/"|"^"|"%"          {
                printf("Signo op\n");
                return (yytext[0]);
                //printf("Signo de operador %s\n");
                }

{MODULO}        {
                printf("operacion modulo \n");
                return (MODULO);
                //printf("Signo de operador %s\n");
                }

{COMA}        {
                printf("coma \n");
                return (COMA);
                //printf("Signo de operador %s\n");
                }

{OPP}			{
                printf("OPP \n");
                return (OPP);
                //printf("Signo de operador %s\n");
                }

{FIN}        {
                printf("Parentesis cierre\n");
                return (FIN);
                //printf("Signo de operador %s\n");
                }

{CADENA}     { 
                printf("Cadena\n", yytext);
                int i=0,j=0;
				int s=strlen(yytext);

				char* x = (char*)malloc(sizeof(yytext));

				for(i=0;i<s-2;i++){
            		x[i]=yytext[i+1];
    			}
    			char y[s];
    			printf("x: %s\n",x );
                yylval.cadena=x;
                return (CADENA);
                }

{TIPO}          {
                  printf("Tipo: %s\n", yytext);
                  strcpy(yylval.tipo,yytext);
                  return(TIPO);
                }

{NOMBRE}         {
                  printf("Nombre: %s\n", yytext);
                   strcpy(yylval.nombre,yytext);
                  return(NOMBRE);
                }

{ASIG}          {
                  printf("Asignacion\n");
                  yylval.asig=yytext;
                  return(ASIG);
                }

{MENOR}          {
                  printf("Menor\n");
                  yylval.menor=yytext;
                  return(MENOR);
                }

{MAYOR}          {
                  printf("Mayor\n");
                  yylval.mayor=yytext;
                  return(MAYOR);
                }

{FINL}          {
                  printf("PuntoyComa\n");
                  yylval.finl=yytext;
                  return(FINL);
                }

{COND}        {
                printf("palabra reservada if \n");
                return (COND);
                //printf("Signo de operador %s\n");
                }

"\n"            {
		          //printf("Salto de linea\n");
                  return (yytext[0]);
                }
%%


//MODULO mod\(({NUM}|{NUMD})\,({NUM}|{NUMD})\)
