%{
#include <stdio.h> 
#include <stdlib.h>
#include <math.h>
#include <string.h>

//Declaro el union y es struct , para guardar los datos de la tabla de simbolos
union tipos{
		char c[30];
		int i;
		float f;
	};

struct dato{
	char tipo[30];
	char nombre[30];
	int id;
	union tipos valor;
};

//funcione que utilizo para meter datos a la tablunion tipos valor;a de simbolos
void ingresar(struct dato *arya, char *tipoT,char *nombreT);
//funcion que imprime toda la tabla de simbolos
void imprimir_propiedades (struct dato *arya);
//funcion que verifica si un dato se encuntra o no en la tabla de simbolos
int verificar (struct dato *arya, char *linea);
//funcion que ingresa un dato a la tabla de simbolos y tambien le asigna un valor
void ingresar_asignacion(struct dato *arya, char *tipoT,char *nombreT, int a, float b, char* c, int N);
//funcion que le asigna un valor a una variable que se envuentre en la tabla de simbolos
void asignacion(struct dato *arya, char* nombre, int a, float b, char* c, int N);
//funcion que te regresa la posicion de una variable buscada dentro de la tabla de simbolos
int verificarP (struct dato *arya, char *linea);
//funcion que invierte una cadena
char *invertirCadena(char *cad);
//variable que guarda el tamaño de la tabla de simbolos inicializada en 1
int tam=1;
// declaro la tabla de simbolos
struct dato *tabla_simbolos;
//funcion que eleva un numero "a" a una potencia "b"
float potencia(float a, float b);
//funcion que saca el modulo "b" de un numero "a" 
float modulo (float a, float b);
//funcion que divide 2 numeros
float divc (int a, int b);
%}
             
/* Declaraciones de BISON */
//union don de guardo los tokens, y les tipo a los no terminales
%union{
	int entero;
	float real;
	char coma[1];
	char opp[1];
	char fin[1];
	char *cond;
	char *menor;
	char *mayor;
	char* cadena;
	char* finl;
	char tipo[20];
	char nombre[20];
	char* asig;	
	struct nodo{
		int tipo;
		union Ttipo{    
			char c[30];
			int i;
			float f;
		} typ;
	}var;
}

//token para numeros enteros
%token <entero> ENTERO
// le asignoo tipo entero a mi no terminal exp
%type <entero> exp

%token <coma> COMA
%token <opp> OPP
%token <fin> FIN

//token para cadena
%token <cadena> CADENA
//le asignoo tipo char a exps
%type <cadena> exps
//token para numeros flotantes
%token <real> FLOTANTE
//tle asigno tipo float a expf
%type <real> expf

%token <tipo> TIPO
// token que utiilizo para validar el nombre de una variable
%token <nombre> NOMBRE
%token <asig> ASIG
%token <finl> FINL
%token <cond> COND
%token <menor> MENOR
%token <mayor> MAYOR

// le signo un tipo var a varible , tipo var es el struct nodo que tiene un union llamado typ, donde se guarda el valor ya sea tipo int,float o char, y tiene una variabel tipo
//para saber que tipo de dato tiene guardado
%type <var> variable

//prioridades de operacion
%left SUMA '-'
%left '*' '/'
%left '^' '%' MODULO
%left OPP



             
/* Gramática */
%%
             
input:    /* cadena vacía */
        | input line             
;

line:     '\n'
		| variable '\n' {printf("");}
        | exp '\n'  { printf ("\tresultado: %d\n", $1); }
        | expf '\n'  { printf ("\tresultado: %f\n", $1); }
        | exps '\n'  { printf ("\tresultado cadena : %s\n", $1); }
        | declaracion '\n' {printf("\n");}
        | asignacion '\n' {printf("\n");}
        | condicion '\n' {printf("\n");}
;
//guarda cualquier combinacion que termine en un entero
             
exp:     ENTERO	{ $$ = $1; } 
	| OPP exp FIN          { $$ = $2;       } // expresion entera dentro de parentesis pata darle prioridad
	| exp SUMA exp        { $$ = $1 + $3;    } // suma de expreciones enteras
	| exp '*' exp        { $$ = $1 * $3;	} 
	| exp '-' exp        { $$ = $1 - $3;	}
	| exp '^' exp        { $$ = potencia($1,$3);    }
	| exp '%' exp        { $$ = $1 % $3;    }
	| MODULO exp COMA exp FIN { $$ = modulo($2,$4);   }
	//| variable            {$$ = $1.i;}
	//| exp '/' exp        { $$ = $1 / $3;	   }


;
//guarda cualquier combinacion que termine en un float
expf:    FLOTANTE { $$ = $1; }
	 | OPP expf FIN          { $$ = $2;       }
	 | expf SUMA expf        { $$ = $1 + $3;    }
	 | exp SUMA expf        { $$ = $1 + $3;    }
	 | expf SUMA exp        { $$ = $1 + $3;    }
	 | expf '-' expf        { $$ = $1 - $3;	   }
	 | exp '-' expf        { $$ = $1 - $3;	   }
	 | expf '-' exp        { $$ = $1 - $3;	   }
	 | expf '*' expf        { $$ = $1 * $3;	   }
	 | exp '*' expf        { $$ = $1 * $3;	  }
	 | expf '*' exp        { $$ = $1 * $3;	  }
	 | expf '/' expf        { $$ = $1 / $3;	   }
	 | exp '/' expf        { $$ = $1 / $3;	   }
	 | expf '/' exp        { $$ = $1 / $3;	   }
	 | exp '/' exp        { $$ = divc($1,$3);	   }
	 | expf '^' expf       { $$ = potencia($1,$3);    }
	 | expf '^' exp        { $$ = potencia($1,$3);    }
	 | exp '^' expf        { $$ = potencia($1,$3);    }
	 | expf '%' expf        { $$ = modulo($1,$3);    }
	 | expf '%' exp        { $$ = modulo($1,$3);    }
	 | exp '%' expf        { $$ = modulo($1,$3);    }
	 | MODULO expf COMA expf FIN { $$ = modulo($2,$4);   }
	 | MODULO expf COMA exp FIN { $$ = modulo($2,$4);   }
	 | MODULO exp COMA expf FIN { $$ = modulo($2,$4);   }
	 //| variable            {$$ = $1.f;}
	 //| MODULO              {$$ = modulo(1,3);}
;

//guarda cualquier combinacion que termine en una cadena
exps:      CADENA { 	$$ = $1;       }
		| exps SUMA exps   { strcat($1,$3);
							$$ =   $1;    }

		| exps '^' exp     { int j=0,i=$3;
								char x[100];
								strcpy(x,$1);
								if(i<0){
									i=i*-1;
									char auxiliar[30];
									strcpy(auxiliar,invertirCadena(x));
        							printf("auxiliar: %s\n",auxiliar);
									strcpy(x,auxiliar);
								}
								strcpy($1,x);
								for(j=0; j<i-1; j++){
									strcat($1,x);
								}
								$$=$1;

		                   };
;

condicion:          COND variable ASIG ASIG exp FIN FINL { if($2.typ.i==$5){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

													}
					|COND variable ASIG ASIG variable FIN FINL {  if($2.tipo==3 && $5.tipo==3){
																		if(strcmp($2.typ.c,$5.typ.c)==0){
																			printf("TRUE\n");
																		}
																		else{
																			printf("FALSE\n");
																		}

																	}

																}

					|COND variable ASIG ASIG expf FIN FINL { if($2.typ.f==$5){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

												}

					|COND variable ASIG ASIG exps FIN FINL { if(strcmp($2.typ.c,$5)==0){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

												}
					|COND exp ASIG ASIG exp FIN FINL { if($2==$5){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

												}
					|COND expf ASIG ASIG expf FIN FINL { if($2==$5){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

													}
					|COND exps ASIG ASIG exps FIN FINL { if(strcmp($2,$5)==0){
															printf("TRUE\n");
														}
														else{
															printf("FALSE\n");
														}

													}

					|COND exp MENOR exp FIN FINL { 		if($2<$4){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

													}

					|COND exp MENOR expf FIN FINL { 		if($2<$4){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

													}

					|COND expf MENOR exp FIN FINL { 		if($2<$4){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

													}

					|COND variable MENOR exp FIN FINL { 		if($2.tipo==1){
															if($2.typ.i<$4){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else if($2.tipo==2){
															if($2.typ.f<$4){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else{
															printf("FALSE\n");
														}

												}
					|COND exp MENOR variable FIN FINL { if($4.tipo==1){
															if($2<$4.typ.i){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else if($2<$4.typ.f){
															if($2<$4.typ.f){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else{
															printf("FALSE\n");
														}

												}
					|COND variable MENOR expf FIN FINL { 	if($2.tipo==1){
															if($2.typ.i<$4){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else if($2.tipo==2){
															if($2.typ.f<$4){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else{
															printf("FALSE\n");
														}

												}

					|COND expf MENOR variable FIN FINL { if($4.tipo==1){
															if($2<$4.typ.i){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else if($2<$4.typ.f){
															if($2<$4.typ.f){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else{
															printf("FALSE\n");
														}

												}
					| COND variable MENOR variable FIN FINL { if($2.tipo==1){
																	if($4.tipo==1){
																		if($2.typ.i<$4.typ.i){
																			printf("TRUE\n");
																		}else{
																			printf("FALSE\n");
																		}

																	}else{
																		if($2.typ.i<$4.typ.f){
																			printf("TRUE\n");
																		}else{
																			printf("FALSE\n");
																		}

																	}
																}
															  else if($2.tipo==2){
															  		if($4.tipo==1){
															  			if($2.typ.f<$4.typ.i){
																			printf("TRUE\n");
																		}else{
																			printf("FALSE\n");
																		}

															  		}else{
															  			if($2.typ.f<$4.typ.f){
																			printf("TRUE\n");
																		}else{
																			printf("FALSE\n");
																		}


															  		}
																	
																}


															}
					////////////////////////////////////////////////////////////////////////////////
					|COND exp MAYOR exp FIN FINL { 		if($2>$4){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

													}

					|COND exp MAYOR expf FIN FINL { 		if($2>$4){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

													}

					|COND expf MAYOR exp FIN FINL { 		if($2>$4){
														printf("TRUE\n");
													}
													else
														printf("FALSE\n");

													}

					|COND variable MAYOR exp FIN FINL { 		if($2.tipo==1){
															if($2.typ.i>$4){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else if($2.tipo==2){
															if($2.typ.f>$4){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else{
															printf("FALSE\n");
														}

												}
					|COND exp MAYOR variable FIN FINL { 		if($4.tipo==1){
															if($2>$4.typ.i){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else if($2<$4.typ.f){
															if($2>$4.typ.f){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else{
															printf("FALSE\n");
														}

												}

					|COND expf MAYOR variable FIN FINL { 		if($4.tipo==1){
															if($2>$4.typ.i){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else if($2<$4.typ.f){
															if($2>$4.typ.f){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else{
															printf("FALSE\n");
														}

												}
					|COND variable MAYOR expf FIN FINL { 		if($2.tipo==1){
															if($2.typ.i>$4){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else if($2.tipo==2){
															if($2.typ.f>$4){
																printf("TRUE\n");
															}
															else{
																printf("FALSE\n");
															}
														}else{
															printf("FALSE\n");
														}

												}


					| COND variable MAYOR variable FIN FINL { if($2.tipo==1){
																	if($4.tipo==1){
																		if($2.typ.i>$4.typ.i){
																			printf("TRUE\n");
																		}else{
																			printf("FALSE\n");
																		}

																	}else{
																		if($2.typ.i>$4.typ.f){
																			printf("TRUE\n");
																		}else{
																			printf("FALSE\n");
																		}

																	}
																}
															  else if($2.tipo==2){
															  		if($4.tipo==1){
															  			if($2.typ.f>$4.typ.i){
																			printf("TRUE\n");
																		}else{
																			printf("FALSE\n");
																		}

															  		}else{
															  			if($2.typ.f>$4.typ.f){
																			printf("TRUE\n");
																		}else{
																			printf("FALSE\n");
																		}


															  		}
																	
																}


															}

;
//no terminal donde estan definidas todas las sintaxis de una declaracion de una variable en la tabla de simbolos
declaracion:    	TIPO NOMBRE FINL {  if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
											tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
										}
										printf("\n");
										ingresar(tabla_simbolos,$1,$2);  // para ingresar la varibale a la tabla de simbolos, mando el tipo y su nombre
									    imprimir_propiedades(tabla_simbolos); // imprimo la tabla de simbolos
									    printf("\n");
									 }
				| TIPO NOMBRE ASIG exp FINL {
													if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
														tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
													}
													printf("\n");
													ingresar_asignacion(tabla_simbolos,$1,$2,$4,0.0,"",1); //para ingresar y asignar valo a una variable, mando su tipo, nombre, valor, y el tipo de el valor
													imprimir_propiedades(tabla_simbolos); // imprimo la tabla de simbolos
										  	  		printf("\n");
												}
				| TIPO NOMBRE ASIG expf FINL {
													if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
														tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
													}
													printf("\n");
													ingresar_asignacion(tabla_simbolos,$1,$2,0,$4,"",2); //para ingresar y asignar valo a una variable, mando su tipo, nombre, valor, y el tipo de el valor
													imprimir_propiedades(tabla_simbolos); // imprimo la tabla de simbolos
										  	  		printf("\n");
												}

				| TIPO NOMBRE ASIG exps FINL {
													if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
														tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
													}
													printf("\n");
													ingresar_asignacion(tabla_simbolos,$1,$2,0,0.0,$4,3); //para ingresar y asignar valo a una variable, mando su tipo, nombre, valor, y el tipo de el valor
													imprimir_propiedades(tabla_simbolos); // imprimo la tabla de simbolos
										  	  		printf("\n");
												}
				| TIPO NOMBRE ASIG variable FINL {
													  if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
															tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
													   }
														printf("\n");

														if(strcmp($1,"int ")==0 && $4.tipo==1 || strcmp($1,"int ")==0 && $4.tipo==2){
															if($4.tipo==1){
																ingresar_asignacion(tabla_simbolos,$1,$2,$4.typ.i,0.0,"",1); //para ingresar y asignar valo a una variable, mando su tipo, nombre, valor, y el tipo de el valor
															}
															else
																ingresar_asignacion(tabla_simbolos,$1,$2,0,$4.typ.f,"",2); //para ingresar y asignar valo a una variable, mando su tipo, nombre, valor, y el tipo de el valor
														}
														else if(strcmp($1,"float ")==0 && $4.tipo==1 || strcmp($1,"float ")==0 && $4.tipo==2){
															if($4.tipo==2){
																ingresar_asignacion(tabla_simbolos,$1,$2,0,$4.typ.f,"",2); //para ingresar y asignar valo a una variable, mando su tipo, nombre, valor, y el tipo de el valor
															}else if($4.tipo==1){
																ingresar_asignacion(tabla_simbolos,$1,$2,$4.typ.i,0.0,"",1); //para ingresar y asignar valo a una variable, mando su tipo, nombre, valor, y el tipo de el valor
															}
														}
														else if(strcmp($1,"char ")==0 && $4.tipo==3){
															ingresar_asignacion(tabla_simbolos,$1,$2,0,0.0,$4.typ.c,3); //para ingresar y asignar valo a una variable, mando su tipo, nombre, valor, y el tipo de el valor
														}
														else{
															printf("Tipos de datos no compatibles\n");
														}
														imprimir_propiedades(tabla_simbolos); // imprimo la tabla de simbolos
												  		printf("\n"); 
										         }


;
//no terminal donde estan definidas todas las sintaxis para asignar un valor a una variable en la tabal de simbololos
asignacion:		NOMBRE ASIG exp FINL{
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											printf("\n");
											asignacion(tabla_simbolos,$1,$3,0.0,"",1); //para asignar valor a la varible , mando tipo, nombre, valor, y el tipo de la variable 
											imprimir_propiedades(tabla_simbolos); // imprimo la tabla de simbolos
										  	printf("\n");
										}

				|NOMBRE ASIG expf FINL {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											printf("\n");
											asignacion(tabla_simbolos,$1,0,$3,"",2); //para asignar valor a la varible , mando tipo, nombre, valor, y el tipo de la variable 
											imprimir_propiedades(tabla_simbolos); // imprimo la tabla de simbolos
										  	printf("\n");
										}
				|NOMBRE ASIG exps FINL {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											printf("\n");
											asignacion(tabla_simbolos,$1,0,0.0,$3,3); //para asignar valor a la varible , mando tipo, nombre, valor, y el tipo de la variable 
											imprimir_propiedades(tabla_simbolos); // imprimo la tabla de simbolos
										  	printf("\n");
										}

				|NOMBRE ASIG variable FINL {
											  if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
													tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											   }
											printf("\n");

											if(verificar(tabla_simbolos,$1)==0){ // verifico si la variable existe en la tabla de simbolos, si no mando mensaje de tabla de simbolos
												int pos=verificarP(tabla_simbolos,$1); //saco la posicion de una variable en la tabla de simbolos
												//verifico de que tipo son las varibles a asignar y si son compatibles se asigna si no mando mensaje de tipos de datos no compatibles
												if(strcmp(tabla_simbolos[pos].tipo,"int ")==0 && $3.tipo==1 || strcmp(tabla_simbolos[pos].tipo,"int ")==0 && $3.tipo==2){
													if($3.tipo==1){
														asignacion(tabla_simbolos,$1,$3.typ.i,0.0,"",1);
													}
													else
														asignacion(tabla_simbolos,$1,0,$3.typ.f,"",2);
												}
												else if(strcmp(tabla_simbolos[pos].tipo,"float ")==0 && $3.tipo==2 || strcmp(tabla_simbolos[pos].tipo,"float ")==0 && $3.tipo==1){
													if($3.tipo==1){
														ingresar_asignacion(tabla_simbolos,$1,$2,$3.typ.i,0.0,"",1);
													}else if($3.tipo==2){
														asignacion(tabla_simbolos,$1,0,$3.typ.f,"",2);
													}
												}
												else if(strcmp(tabla_simbolos[pos].tipo,"char ")==0 && $3.tipo==3){
													asignacion(tabla_simbolos,$1,0,0.0,$3.typ.c,3);
												}
												else{
													printf("Tipos de datos no compatibles\n");
												}
												imprimir_propiedades(tabla_simbolos); // imprimo la tabla de simbolos
										  		printf("\n"); 
										  	}else
										  		printf("variable no declarada\n");
										  }
;

//no terminal donde verifica todas las sintaxis que tiene como resilltado una varibale
variable:    	 NOMBRE  {	if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
								tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
							}
							if(verificar(tabla_simbolos,$1)==0){ //verifico si el nombre de la varible existe en la tabla de simbolos
								int pos=verificarP(tabla_simbolos,$1);  //saco la posicion de
								if(strcmp(tabla_simbolos[pos].tipo,"int ")==0){
									$$.tipo=1; // asigno el tipo a la varible
									$$.typ.i=tabla_simbolos[pos].valor.i; // asigno el valor 
								}
								else if(strcmp(tabla_simbolos[pos].tipo,"float ")==0){
									$$.tipo=2; // asigno el tipo a la varible
									$$.typ.f=tabla_simbolos[pos].valor.f; // asigno el valor 
								}
								else if(strcmp(tabla_simbolos[pos].tipo,"char ")==0){
									$$.tipo=3; // asigno el tipo a la varible
									strcpy($$.typ.c,tabla_simbolos[pos].valor.c); // asigno el valor 
								}
							}else
								printf("variable no declarada\n");

					 	}

				| variable SUMA variable {
											if(tam==1){ //verifico si ya esta creada o no la tabla de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1 && $3.tipo==1){
												$$.typ.i=$1.typ.i+$3.typ.i;
												$$.tipo=1; // asigno el tipo a la varible
											}
											else if($1.tipo==2 && $3.tipo==2 || $1.tipo==2 && $3.tipo==1 || $1.tipo==1 && $3.tipo==2 ){
												if($1.tipo==2 && $3.tipo==2){
													$$.typ.f=$1.typ.f+$3.typ.f;
												}else if($1.tipo==2 && $3.tipo==1){
													$$.typ.f=$1.typ.f+$3.typ.i;
												}else{
													$$.typ.f=$1.typ.i+$3.typ.f;
												}
												$$.tipo=2; // asigno el tipo a la varible
											}
											else if($1.tipo==3 && $3.tipo==3){
												strcat($1.typ.c,$3.typ.c);
												strcpy($$.typ.c,$1.typ.c);
												$$.tipo=3;		// asigno el tipo a la varible									
											}else
												printf("tipos de datos no compatibles o variable no declarada\n");
					 					 }

				| variable SUMA exp {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1){
												$$.typ.i=$1.typ.i+$3;
												$$.tipo=1;
											}
											else if($1.tipo==2){
												$$.typ.f=$1.typ.f+$3;
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 
				| exp SUMA variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==1){
												$$.typ.i=$3.typ.i+$1;
												$$.tipo=1;
											}
											else if($3.tipo==2){
												$$.typ.f=$3.typ.f+$1;
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| variable SUMA expf {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1){
												$$.typ.i=$1.typ.i+$3;
												$$.tipo=2;
											}
											else if($1.tipo==2){
												$$.typ.f=$1.typ.f+$3;
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 
				| expf SUMA variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==1){
												$$.typ.f=$3.typ.i+$1;
												$$.tipo=2;
											}
											else if($3.tipo==2){
												$$.typ.f=$3.typ.f+$1;
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| exps SUMA variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==3){
												strcat($1,$3.typ.c);
												strcpy($$.typ.c,$1);
												$$.tipo=3;			
											}else
												printf("tipos de datos no compatibles\n");

					 				}

				| variable SUMA exps {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==3){
												strcat($1.typ.c,$3);
												strcpy($$.typ.c,$1.typ.c);
												$$.tipo=3;			
											}else
												printf("tipos de datos no compatibles\n");

					 				}

				| variable '*' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1 && $3.tipo==1){
												$$.typ.i=$1.typ.i*$3.typ.i;
												$$.tipo=1;
											}
											else if($1.tipo==2 && $3.tipo==2 || $1.tipo==2 && $3.tipo==1 || $1.tipo==1 && $3.tipo==2 ){
												if($1.tipo==2 && $3.tipo==2){
													$$.typ.f=$1.typ.f*$3.typ.f;
												}else if($1.tipo==2 && $3.tipo==1){
													$$.typ.f=$1.typ.f*$3.typ.i;
												}else{
													$$.typ.f=$1.typ.i*$3.typ.f;
												}
												$$.tipo=2;										
											}else
												printf("tipos de datos no compatibles\n");

					 					 } 
				| variable '*' exp {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1){
												$$.typ.i=$1.typ.i*$3;
												$$.tipo=1;
											}
											else if($1.tipo==2){
												$$.typ.f=$1.typ.f*$3;
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 
				| exp '*' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==1){
												$$.typ.i=$3.typ.i*$1;
												$$.tipo=1;
											}
											else if($3.tipo==2){
												$$.typ.f=$3.typ.f*$1;
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| variable '*' expf {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1){
												$$.typ.f=$1.typ.i*$3;
												$$.tipo=2;
											}
											else if($1.tipo==2){
												$$.typ.f=$1.typ.f*$3;
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 
				| expf '*' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==1){
												$$.typ.f=$3.typ.i*$1;
												$$.tipo=2;
											}
											else if($3.tipo==2){
												$$.typ.f=$3.typ.f*$1;
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| variable '-' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1 && $3.tipo==1){
												$$.typ.i=$1.typ.i-$3.typ.i;
												$$.tipo=1;
											}
											else if($1.tipo==2 && $3.tipo==2 || $1.tipo==2 && $3.tipo==1 || $1.tipo==1 && $3.tipo==2 ){
												if($1.tipo==2 && $3.tipo==2){
													$$.typ.f=$1.typ.f-$3.typ.f;
												}else if($1.tipo==2 && $3.tipo==1){
													$$.typ.f=$1.typ.f-$3.typ.i;
												}else{
													$$.typ.f=$1.typ.i-$3.typ.f;
												}
												$$.tipo=2;										
											}else
												printf("tipos de datos no compatibles\n");

					 					 } 
				| variable '-' exp {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1){
												$$.typ.i=$1.typ.i-$3;
												$$.tipo=1;
											}
											else if($1.tipo==2){
												$$.typ.f=$1.typ.f-$3;
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 
				| exp '-' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==1){
												$$.typ.i=$1-$3.typ.i;
												$$.tipo=1;
											}
											else if($3.tipo==2){
												$$.typ.f=$1-$3.typ.f;
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");

					 				}

				| variable '-' expf {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1){
												$$.typ.f=$1.typ.i-$3;
												$$.tipo=2;
											}
											else if($1.tipo==2){
												$$.typ.f=$1.typ.f-$3;
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 
				| expf '-' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==1){
												$$.typ.f=$1-$3.typ.i;
												$$.tipo=2;
											}
											else if($3.tipo==2){
												$$.typ.f=$1-$3.typ.f;
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");

					 				}
				| variable '/' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1 && $3.tipo==1){
												$$.typ.f=divc($1.typ.i,$3.typ.i);
												$$.tipo=1;
											}
											else if($1.tipo==2 && $3.tipo==2 || $1.tipo==2 && $3.tipo==1 || $1.tipo==1 && $3.tipo==2 ){
												if($1.tipo==2 && $3.tipo==2){
													$$.typ.f=$1.typ.f/$3.typ.f;
												}else if($1.tipo==2 && $3.tipo==1){
													$$.typ.f=$1.typ.f/$3.typ.i;
												}else{
													$$.typ.f=$1.typ.i/$3.typ.f;
												}
												$$.tipo=2;										
											}else
												printf("tipos de datos no compatibles\n");

					 					 } 
				| variable '/' exp {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1){
												$$.typ.f=divc($1.typ.i,$3);
												$$.tipo=2;
											}
											else if($1.tipo==2){
												$$.typ.f=$1.typ.f/$3;
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 
				| exp '/' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==1){
												$$.typ.f=divc($1,$3.typ.i);
												$$.tipo=2;
											}
											else if($3.tipo==2){
												$$.typ.f=$1/$3.typ.f;
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");
					 				}

				| variable '/' expf {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1){
												$$.typ.f=divc($1.typ.i,$3);
												$$.tipo=2;
											}
											else if($1.tipo==2){
												$$.typ.f=$1.typ.f/$3;
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| expf '/' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==1){
												$$.typ.f=divc($1,$3.typ.i);
												$$.tipo=2;
											}
											else if($3.tipo==2){
												$$.typ.f=$1/$3.typ.f;
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");
					 				}

				| variable '^' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1 && $3.tipo==1){
												$$.typ.i=potencia($1.typ.i,$3.typ.i);
												$$.tipo=1;
											}
											else if($1.tipo==2 && $3.tipo==2 || $1.tipo==2 && $3.tipo==1 || $1.tipo==1 && $3.tipo==2 ){
												if($1.tipo==2 && $3.tipo==2){
													$$.typ.f=potencia($1.typ.f,$3.typ.f);
												}else if($1.tipo==2 && $3.tipo==1){
													$$.typ.f=potencia($1.typ.f,$3.typ.i);
												}else{
													$$.typ.f=potencia($1.typ.i,$3.typ.f);
												}
												$$.tipo=2;		
											}else if($1.tipo==3 && $3.tipo==1){
												int j=0,i=$3.typ.i;
												char x[100];
												strcpy(x,$1.typ.c);
												int tam=strlen(x);
												if(i<0){
													i=i*-1;
													char auxiliar[30];
													strcpy(auxiliar,invertirCadena(x));
        											printf("auxiliar: %s\n",auxiliar);
													strcpy(x,auxiliar);
												}
												strcpy($1.typ.c,x);
												for(j=0; j<i-1; j++){
													strcat($1.typ.c,x);
												}
												strcpy($$.typ.c,$1.typ.c);
												$$.tipo=3;										
											}else
												printf("tipos de datos no compatibles\n");

					 					 } 
				| variable '^' exp {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1){
												$$.typ.i=potencia($1.typ.i,$3);
												$$.tipo=1;
											}
											else if($1.tipo==2){
												$$.typ.f=potencia($1.typ.f,$3);
												$$.tipo=2;		

											}else if($1.tipo==3){
												int j=0,i=$3;
												char x[30];
												strcpy(x,$1.typ.c);
												int tam=strlen(x);
												if(i<0){
													i=i*-1;
													char auxiliar[100];
													strcpy(auxiliar,invertirCadena(x));
        											printf("auxiliar: %s\n",auxiliar);
													strcpy(x,auxiliar);
												}
												strcpy($1.typ.c,x);
												for(j=0; j<i-1; j++){
													strcat($1.typ.c,x);
												}
												strcpy($$.typ.c,$1.typ.c);
												$$.tipo=3;		
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| exp '^' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==1){
												$$.typ.i=potencia($1,$3.typ.i);
												$$.tipo=1;
											}
											else if($3.tipo==2){
												$$.typ.f=potencia($3.typ.f,$1);
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| variable '^' expf {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($1.tipo==1){
												$$.typ.f=potencia($1.typ.i,$3);
												$$.tipo=2;
											}
											else if($1.tipo==2){
												$$.typ.f=potencia($1.typ.f,$3);
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 
				| expf '^' variable {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($3.tipo==1){
												$$.typ.f=potencia($1,$3.typ.i);
												$$.tipo=2;
											}
											else if($3.tipo==2){
												$$.typ.f=potencia($1,$3.typ.i);
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| MODULO variable COMA variable FIN {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($2.tipo==1 && $4.tipo==1){
												$$.typ.i=modulo($2.typ.i,$4.typ.i);
												$$.tipo=1;
											}
											else if($2.tipo==2 && $4.tipo==2 || $2.tipo==2 && $4.tipo==1 || $2.tipo==1 && $4.tipo==2 ){
												if($2.tipo==2 && $4.tipo==2){
													$$.typ.f=modulo($2.typ.f,$4.typ.f);
												}else if($2.tipo==2 && $4.tipo==1){
													$$.typ.f=modulo($2.typ.f,$4.typ.i);
												}else{
													$$.typ.f=modulo($2.typ.i,$4.typ.f);
												}
												$$.tipo=2;										
											}else
												printf("tipos de datos no compatibles\n");

					 					 } 
				| MODULO variable COMA exp FIN {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($2.tipo==1){
												$$.typ.i=modulo($2.typ.i,$4);
												$$.tipo=1;
											}
											else if($2.tipo==2){
												$$.typ.f=modulo($2.typ.f,$4);
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 
				| MODULO exp COMA variable FIN  {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($4.tipo==1){
												$$.typ.i=modulo($2,$4.typ.i);
												$$.tipo=1;
											}
											else if($4.tipo==2){
												$$.typ.f=modulo($2,$4.typ.f);
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| MODULO variable COMA expf FIN  { //verifico si ya esta creada o no la tabal de simbolos
											if(tam==1){
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($2.tipo==1){
												$$.typ.f=modulo($2.typ.i,$4);
												$$.tipo=2;
											}
											else if($2.tipo==2){
												$$.typ.f=modulo($2.typ.f,$4);
												$$.tipo=2;					
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| MODULO expf COMA variable FIN  {
											if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
												tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
											}
											// verifico los tipos de datos de las varibles y si son compatibles hago la operacion
											if($4.tipo==1){
												$$.typ.f=modulo($2,$4.typ.i);
												$$.tipo=2;
											}
											else if($4.tipo==2){
												$$.typ.f=modulo($2,$4.typ.f);
												$$.tipo=2;				
											}else
												printf("tipos de datos no compatibles\n");

					 				} 

				| OPP variable FIN  {   
										if(tam==1){ //verifico si ya esta creada o no la tabal de simbolos
											tabla_simbolos=(struct dato*)malloc(sizeof(struct dato)*tam);
										}
										//verifico el tipo de la varible
										if($2.tipo==1){
											$$.tipo=1; //le asgno tipoo
											$$.typ.i=$2.typ.i; //asigno valor
										}else if($2.tipo==2){
											$$.tipo=2; //le asgno tipoo
											$$.typ.f=$2.typ.f; //asigno valor
										}else if($2.tipo==3){
											$$.tipo=3; //le asgno tipoo
											strcpy($$.typ.c,$2.typ.c); //asigno valor
										}


									}


;  
%%
int main() {
  yyparse();
}
             
yyerror (char *s)
{
  printf ("--%s--\n", s);
}
            
int yywrap()  
{  
  return 1;  
}  
float potencia(float a, float b){ //funcion de potencia
	return pow(a,b);
}

float modulo (float a, float b){ //funcion de modulo
	return fmod(a, b);
}

float divc (int a, int b){ // funfcion de divicion 
	float c=a;
	return c/b;
}

void ingresar(struct dato *arya, char *tipoT,char *nombreT){ //funcion para ingresar una varible a la tabla de simbolos
	int cont=0;
	//arya es el nombre que utilizare en esta funcion, que apunta a la tabla de simbolos
	if(verificar(arya,nombreT)==1){ ///verifico si el nombre de la varible no existe , para asi poderla ingresar a la tabla de simbolos
		strcpy(arya[tam-1].tipo,tipoT);  //ingreso en la ultima posicion de la tabla de simbolos un nuevo tipo
		strcpy(arya[tam-1].nombre,nombreT);  //ingreso en la ultima posicion de la tabla de simbolos un nuevo nombre 
		// empeizo hacer las comparaciones para ver de que tipo es la varibale ingresada y asi poderle asignar un valor de 0,0.0 o "", respecto a su tipo
		if(strcmp(arya[tam-1].tipo,"int ")==0){     
			arya[tam-1].valor.i=0;
		}
		else if(strcmp(arya[tam-1].tipo,"float ")==0){
			arya[tam-1].valor.f=0.0;
		}
		else if(strcmp(arya[tam-1].tipo,"char ")==0){
			strcpy(arya[tam-1].valor.c,"");
		}
		arya[tam-1].id=tam;
		tam++;	
	}else{
		printf("error: Nombre de variable ya ah sido asignada\n");
	}
}

void ingresar_asignacion(struct dato *arya, char *tipoT,char *nombreT, int a, float b, char* c,int N){  //funcion para ingresar una varible y un valor a la tabla de simbolos
	int ban=0;  // bandera que utilizo para saber si el dato con el tipo de dato de la varible fueron o no compatibles, para que si lo fueron aumentar el tamaño a la tabla de simbolos
	//arya es el nombre que utilizare en esta funcion, que apunta a la tabla de simbolos
	if(verificar(arya,nombreT)==1){ ///verifico si el nombre de la varible no existe , para asi poderla ingresar a la tabla de simbolos, si no mando mensaje de variable ya declarada
		strcpy(arya[tam-1].tipo,tipoT);  //ingreso en la ultima posicion de la tabla de simbolos un nuevo tipo
		strcpy(arya[tam-1].nombre,nombreT);  //ingreso en la ultima posicion de la tabla de simbolos un nuevo tipoo
		// empiezo a hacer las comparaciones para ver de que tipo es la varibale ingresada, y ver si es compatible con el tipo de dato de el valor a asignarle
		//si sus datos no son compatibles mandara mensaje de datos no compatibles  
		//N variable que guarda que tipo de dato de el valor a asignar se envio, donde N=1 es entero, N=2 es float, N=3 es char
		if(strcmp(arya[tam-1].tipo,"int ")==0){
			if(N==1){
				ban=1;
				arya[tam-1].valor.i=a;
			}else if(N==2){
				ban=1;
				arya[tam-1].valor.i=b;
			}else                                  
				printf("error: tipos de datos no compatibles\n");
		}
		else if(strcmp(arya[tam-1].tipo,"float ")==0){
			if(N==2){
				ban=1;
				arya[tam-1].valor.f=b;
			}else if(N==1){
				ban=1;
				arya[tam-1].valor.f=a;
			}else
				printf("error: tipos de datos no compatibles\n");
		}
		else if(strcmp(arya[tam-1].tipo,"char ")==0){
			if(N==3){
				ban=1;
				strcpy(arya[tam-1].valor.c,c);
			}else
				printf("error: tipos de datos no compatibles\n");
		}
		if(ban==1){   /// si es que entro en alguna de las condicones validas, entra aqui gracias a ban , donde agrega el id a la varible y aunmenta el tamaño de la tabla de simbolos
			arya[tam-1].id=tam;
			tam++;	
		}
		strcpy(arya[tam-1].tipo,"");
		strcpy(arya[tam-1].nombre,"");
	}else{
		printf("error: Nombre de variable ya ah sido asignada\n");
	}
}

void asignacion(struct dato *arya, char* nombre, int a, float b, char* c, int N){ // funcion que asigna valor a una variable
	//arya es el nombre que utilizare en esta funcion, que apunta a la tabla de simbolos
	if(verificar(arya,nombre)==0){  // verifico si ya existe la varible a asignarle un valor , si no, mando mensaje de variable no declarada
		int posicion=verificarP(arya,nombre);  //verifico que posicion tiene la varible a asignarle un valor dentro de la tabla de simbolos
		// verifico de que tipo es la varible a la que le asignaremos un valor, si sus datos no son compatibles mandara mensaje de datos no compatibles
		//N variable que guarda que tipo de dato de el valor a asignar se envio, donde N=1 es entero, N=2 es float, N=3 es char
		if(strcmp(arya[posicion].tipo,"int ")==0){ 
			if(N==1){
				arya[posicion].valor.i=a;
			}else if(N==2){
				arya[posicion].valor.i=b;
			}else
				printf("error: tipo de dato diferente\n");
		}
		else if(strcmp(arya[posicion].tipo,"float ")==0){
			if(N==2){
				arya[posicion].valor.f=b;
			}else if(N==1){
				arya[posicion].valor.f=a;
			}else
				printf("error: tipo de dato diferente\n");
		}
		else if(strcmp(arya[posicion].tipo,"char ")==0){
			if(N==3){
				strcpy(arya[posicion].valor.c,c);
			}else
				printf("error: tipo de dato diferente\n");
		}

	}
	else{
		printf("nombre de la variable no esta declarada\n");
	}

}

void imprimir_propiedades (struct dato *arya){       /// funcion que imprime toda la tabla de simbolos
	printf("%-15s%-15s%-15s%-15s \n","ID","Tipo","Nombre","Valor");	  // print que tabula las columnas de la tabla
	int i=0, Valor=0;
	for(i=0;i<=tam-2;i++){
		printf("%-15d",arya[i].id);    //imprime el id de la varible
		printf("%-15s",arya[i].tipo);  //imprime el tipo de la varible
		printf("%-15s",arya[i].nombre); //imprime el nombre de la varible
		// verifica que tipo de dato tiene la varible y al que concida imprime su valor
		if(strcmp(arya[i].tipo,"int ")==0){
			printf("%-15d\n",arya[i].valor.i);
		}
		else if(strcmp(arya[i].tipo,"float ")==0){
			printf("%-15f\n",arya[i].valor.f);
		}
		else if(strcmp(arya[i].tipo,"char ")==0){
			printf("%-15s\n",arya[i].valor.c);
		}
	}
	printf("\n");
}

int verificar (struct dato *arya, char *linea){  // verifica si existe o no una variable dentro de la tabla de simbolos, regresa 1 si no existe y 0 si existe
	int i=0;
	for(i=0; i<=tam-1;i++){
		if(strcmp(arya[i].nombre,linea)==0){
			return 0;
		}
	}
	return 1;
}

int verificarP (struct dato *arya, char *linea){ // verifica que posicion dentro de la tabla tiene una variable
	int i=0;
	for(i=0; i<=tam-1;i++){
		if(strcmp(arya[i].nombre,linea)==0){
			return i;
		}
	}
}

char *invertirCadena(char *cad){  // invierte una cadena
	 int i, j=strlen(cad);
	 char c;
	for(i=0, j=strlen(cad)-1; i<j; i++, j--)
	 {
          c=cad[i];
          cad[i]=cad[j];
          cad[j]=c;
     }
    return cad;
}

