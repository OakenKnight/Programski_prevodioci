//OPIS: do while ispisuje i
//RETURN: 14

int main() {
  int suma;
  int i;
	int k;
  suma=0;
	i=0;
 	do{
		do{
		suma = suma + 1;
		k++;
		}while(k<2);

		suma = suma + i;		
		i++;
		}while ( i < 1 );
	return suma;
}
