//OPIS: while ispisuje i
//RETURN: 20

int main() {
  int suma;
  int i;
	int j;
	j=0;
  suma=0;
	i=0;
 	while ( i < 5 ) {
		while( j < 4 ){
			i = 0;
			j++;
		}

		suma = suma + j;

		i++;
	}
	return suma;
}
